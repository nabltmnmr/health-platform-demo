import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/repositories/inventory_repository.dart';
import '../../../shared/widgets/empty_state.dart';

class SupplyReceiptHistoryScreen extends ConsumerStatefulWidget {
  const SupplyReceiptHistoryScreen({super.key});

  @override
  ConsumerState<SupplyReceiptHistoryScreen> createState() => _SupplyReceiptHistoryScreenState();
}

class _SupplyReceiptHistoryScreenState extends ConsumerState<SupplyReceiptHistoryScreen> {
  final _supplierFilterController = TextEditingController();
  SupplySourceType? _sourceFilter;

  @override
  void dispose() {
    _supplierFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final supplierQuery = _supplierFilterController.text;
    final receipts = supplierQuery.trim().isEmpty
        ? invRepo.getSupplyReceiptsSortedByDate()
        : invRepo.getSupplyReceiptsBySupplier(supplierQuery);
    final filtered = _sourceFilter == null
        ? receipts
        : receipts.where((r) => r.sourceType == _sourceFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Received supplies', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text('All supplies received into institute inventory (DRUG DEPOT), dated and sortable by supplier.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _supplierFilterController,
            decoration: const InputDecoration(
              labelText: 'Filter by supplier',
              hintText: 'Search supplier name...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _sourceFilter == null,
                  onSelected: (_) => setState(() => _sourceFilter = null),
                ),
                const SizedBox(width: 8),
                ...SupplySourceType.values.map((e) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(e.label),
                    selected: _sourceFilter == e,
                    onSelected: (_) => setState(() => _sourceFilter = _sourceFilter == e ? null : e),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: EmptyState(icon: Icons.receipt_long, title: 'No received supplies'),
            )
          else
            ...filtered.map((r) => _ReceiptCard(receipt: r, invRepo: invRepo)),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt, required this.invRepo});

  final SupplyReceipt receipt;
  final InventoryRepository invRepo;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ExpansionTile(
        title: Text(receipt.supplierName, style: Theme.of(context).textTheme.titleSmall),
        subtitle: Text(
          '${DateFormat.yMMMd().format(receipt.receivedAt)} · ${receipt.sourceType.label} · ${receipt.lineItems.length} line(s)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (receipt.referenceNumber != null) _row(context, 'Reference', receipt.referenceNumber!),
                _row(context, 'Source', receipt.sourceType.label),
                _row(context, 'Received', DateFormat.yMMMd().format(receipt.receivedAt)),
                if (receipt.notes != null && receipt.notes!.isNotEmpty) _row(context, 'Notes', receipt.notes!),
                const SizedBox(height: 8),
                Text('Line items', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                ...receipt.lineItems.map((line) {
                  final brandList = invRepo.brands.where((b) => b.id == line.productBrandId).toList();
                  final brand = brandList.isNotEmpty ? brandList.first : null;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('${brand?.brandName ?? line.productBrandId} — ${line.batchNumber} · ${line.quantity} · Exp ${DateFormat.yMd().format(line.expiryDate)}', style: Theme.of(context).textTheme.bodySmall),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
