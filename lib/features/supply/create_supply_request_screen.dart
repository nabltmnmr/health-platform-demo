import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';

/// Create a supply request from a pharmacy to inventory. Requires approval from inventory manager.
class CreateSupplyRequestScreen extends ConsumerStatefulWidget {
  const CreateSupplyRequestScreen({super.key, required this.pharmacyId});

  final String pharmacyId;

  @override
  ConsumerState<CreateSupplyRequestScreen> createState() => _CreateSupplyRequestScreenState();
}

class _CreateSupplyRequestScreenState extends ConsumerState<CreateSupplyRequestScreen> {
  String? _productId;
  final _quantityController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final products = invRepo.nationalProducts;
    final locs = SeedData.stockLocations.where((l) => l.id == widget.pharmacyId).toList();
    final pharmacyName = locs.isNotEmpty ? locs.first.name : widget.pharmacyId;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Request supply', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Request will be sent to inventory manager for approval.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_pharmacy),
              title: const Text('Requesting pharmacy'),
              subtitle: Text(pharmacyName),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          DropdownButtonFormField<String>(
            value: _productId,
            decoration: const InputDecoration(labelText: 'Product'),
            items: products.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.name} ${p.form}'))).toList(),
            onChanged: (v) => setState(() => _productId = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _productId == null ? null : _submit,
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Submit request'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final qty = int.tryParse(_quantityController.text.trim());
    if (qty == null || qty < 1 || _productId == null) return;

    final id = 'sr-${const Uuid().v4().substring(0, 8)}';
    final request = SupplyRequest(
      id: id,
      requestingLocationId: widget.pharmacyId,
      productNationalId: _productId!,
      quantity: qty,
      status: SupplyRequestStatus.pending,
      requestedAt: DateTime.now(),
    );
    ref.read(inventoryRepositoryProvider).addSupplyRequest(request);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request submitted. Pending approval from inventory manager.')));
      context.pop();
    }
  }
}
