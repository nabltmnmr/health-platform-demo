import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/repositories/inventory_repository.dart';

/// Parse "MM/yyyy" or "MM/yy" to last day of that month. Returns null if invalid.
DateTime? _parseExpiryMMYYYY(String text) {
  final t = text.trim().replaceAll(' ', '');
  if (t.length < 5) return null; // need at least MM/YY
  final parts = t.split('/');
  if (parts.length != 2) return null;
  final m = int.tryParse(parts[0]);
  var y = int.tryParse(parts[1]);
  if (m == null || y == null || m < 1 || m > 12) return null;
  if (y < 100) y += 2000; // 27 -> 2027
  if (y < 2000 || y > 2100) return null;
  return DateTime(y, m + 1, 0); // last day of month
}

/// Formatter: digits only, auto-insert "/" after 2 digits, max MM/YYYY (7 chars).
class _ExpiryMMYYYYFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return TextEditingValue(text: '', selection: const TextSelection.collapsed(offset: 0));
    final mm = digits.length >= 2 ? digits.substring(0, 2) : digits;
    final yy = digits.length > 2 ? digits.substring(2, digits.length > 6 ? 6 : digits.length) : '';
    // Always show MM/ when we have at least 2 digits, so "/" is auto-added
    final text = mm.length >= 2 ? '$mm/$yy' : mm;
    final offset = text.length;
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: offset));
  }
}

class ReceiveSupplyScreen extends ConsumerStatefulWidget {
  const ReceiveSupplyScreen({super.key});

  @override
  ConsumerState<ReceiveSupplyScreen> createState() => _ReceiveSupplyScreenState();
}

class _ReceiveSupplyScreenState extends ConsumerState<ReceiveSupplyScreen> {
  SupplySourceType _sourceType = SupplySourceType.healthDepartmentSupply;
  final _supplierController = TextEditingController();
  final _refController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _receivedDate = DateTime.now();
  final _lines = <_ReceiptLine>[];

  @override
  void initState() {
    super.initState();
    final first = _ReceiptLine();
    _setDefaultExpiry(first);
    _lines.add(first);
  }

  void _setDefaultExpiry(_ReceiptLine line) {
    final d = DateTime.now().add(const Duration(days: 365));
    line.expiryController.text = DateFormat('MM/yyyy').format(d);
    line.expiryDate = _parseExpiryMMYYYY(line.expiryController.text);
  }

  @override
  void dispose() {
    _supplierController.dispose();
    _refController.dispose();
    _notesController.dispose();
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Register received supply', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Record products received from outside (transfer, health dept, or 3rd party). Stock is added to DRUG DEPOT.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Source', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<SupplySourceType>(
                    value: _sourceType,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: SupplySourceType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.label))).toList(),
                    onChanged: (v) => setState(() => _sourceType = v ?? _sourceType),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _supplierController,
                    decoration: const InputDecoration(labelText: 'Supplier / source name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _refController,
                    decoration: const InputDecoration(labelText: 'Reference number (optional)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Received date'),
                    subtitle: Text(DateFormat.yMMMd().format(_receivedDate)),
                    trailing: TextButton(
                      onPressed: () async {
                        final d = await showDatePicker(context: context, initialDate: _receivedDate, firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)));
                        if (d != null) setState(() => _receivedDate = d);
                      },
                      child: const Text('Change'),
                    ),
                  ),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Notes (optional)', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Line items', style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                onPressed: () => setState(() {
                  final line = _ReceiptLine();
                  _setDefaultExpiry(line);
                  _lines.add(line);
                }),
                icon: const Icon(Icons.add),
                label: const Text('Add line'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._lines.asMap().entries.map((e) {
            final i = e.key;
            final line = e.value;
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _ReceiptLineForm(
                  line: line,
                  invRepo: invRepo,
                  onRemove: _lines.length > 1 ? () => setState(() { line.dispose(); _lines.removeAt(i); }) : null,
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Register receipt'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final supplier = _supplierController.text.trim();
    if (supplier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter supplier / source name')));
      return;
    }
    final invRepo = ref.read(inventoryRepositoryProvider);
    const uuid = Uuid();
    final validLines = <SupplyReceiptLine>[];

    for (final line in _lines) {
      final brandName = line.brandNameController.text.trim();
      final productNationalId = line.selectedNationalProductId;
      final batchNumber = line.batchNumberController.text.trim();
      final qty = int.tryParse(line.quantityController.text.trim());
      // Parse expiry from MM/YYYY if not already set
      final expiry = line.expiryDate ?? _parseExpiryMMYYYY(line.expiryController.text);
      if (brandName.isEmpty || productNationalId == null || productNationalId.isEmpty || batchNumber.isEmpty || qty == null || qty <= 0 || expiry == null) continue;

      // Find or create brand for this national product + brand name
      var brand = invRepo.findBrandByNationalIdAndName(productNationalId, brandName);
      if (brand == null) {
        brand = ProductBrand(
          id: 'brand-${uuid.v4().substring(0, 8)}',
          productNationalId: productNationalId,
          brandName: brandName,
          companyName: brandName,
        );
        invRepo.addBrand(brand);
        final product = invRepo.getNationalProduct(productNationalId);
        if (product != null) {
          invRepo.updateNationalProduct(ProductNationalIdentifier(
            id: product.id,
            name: product.name,
            form: product.form,
            brandIds: [...product.brandIds, brand.id],
          ));
        }
      }
      validLines.add(SupplyReceiptLine(productBrandId: brand.id, batchNumber: batchNumber, quantity: qty, expiryDate: expiry));
    }

    if (validLines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add at least one valid line (brand name, national identifier, batch number, quantity, expiry)')));
      return;
    }

    final receiptId = 'rec-${uuid.v4().substring(0, 8)}';

    for (final line in validLines) {
      final batchId = 'batch-${uuid.v4().substring(0, 8)}';
      final batch = StockBatch(
        id: batchId,
        productBrandId: line.productBrandId,
        locationId: 'loc-drug-depot',
        batchNumber: line.batchNumber,
        expiryDate: line.expiryDate,
        quantity: line.quantity,
        receivedAt: _receivedDate,
      );
      invRepo.addBatch(batch);
    }

    final receipt = SupplyReceipt(
      id: receiptId,
      receivedAt: _receivedDate,
      sourceType: _sourceType,
      supplierName: supplier,
      referenceNumber: _refController.text.trim().isEmpty ? null : _refController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      lineItems: validLines,
    );
    invRepo.addSupplyReceipt(receipt);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receipt registered. Stock added to DRUG DEPOT.')));
      context.pop();
    }
  }
}

class _ReceiptLine {
  final brandNameController = TextEditingController();
  final batchNumberController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final expiryController = TextEditingController(); // MM/YYYY, "/" auto-added
  String? selectedNationalProductId; // which national identifier (product) this line belongs to
  DateTime? expiryDate; // parsed from expiryController when valid MM/YYYY

  void dispose() {
    brandNameController.dispose();
    batchNumberController.dispose();
    quantityController.dispose();
    expiryController.dispose();
  }
}

class _ReceiptLineForm extends StatefulWidget {
  const _ReceiptLineForm({required this.line, required this.invRepo, this.onRemove});

  final _ReceiptLine line;
  final InventoryRepository invRepo;
  final VoidCallback? onRemove;

  @override
  State<_ReceiptLineForm> createState() => _ReceiptLineFormState();
}

class _ReceiptLineFormState extends State<_ReceiptLineForm> {
  ProductNationalIdentifier? _selectedNationalProduct;

  @override
  Widget build(BuildContext context) {
    final products = widget.invRepo.nationalProducts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.line.brandNameController,
                decoration: const InputDecoration(
                  labelText: 'Brand / product name',
                  hintText: 'Type the brand or product name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (widget.onRemove != null)
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: widget.onRemove),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ProductNationalIdentifier>(
          value: _selectedNationalProduct,
          decoration: const InputDecoration(
            labelText: 'National identifier',
            hintText: 'Select which product this belongs to',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('Select national identifier')),
            ...products.map((p) => DropdownMenuItem(
              value: p,
              child: Text('${p.name} — ${p.form}'),
            )),
          ],
          onChanged: (p) {
            setState(() {
              _selectedNationalProduct = p;
              widget.line.selectedNationalProductId = p?.id;
            });
          },
        ),
        if (_selectedNationalProduct != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 0),
            child: Text(
              'Dosage form: ${_selectedNationalProduct!.form}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
        const SizedBox(height: 8),
        TextField(
          controller: widget.line.batchNumberController,
          decoration: const InputDecoration(labelText: 'Batch number', border: OutlineInputBorder(), isDense: true),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.line.quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder(), isDense: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: widget.line.expiryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Expiry',
                  hintText: 'MM/YYYY',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(7),
                  _ExpiryMMYYYYFormatter(),
                ],
                onChanged: (value) {
                  final parsed = _parseExpiryMMYYYY(value);
                  widget.line.expiryDate = parsed;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
