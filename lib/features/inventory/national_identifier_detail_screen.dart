import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../app/theme/radii.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_chip.dart';

class NationalIdentifierDetailScreen extends ConsumerWidget {
  const NationalIdentifierDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final supRepo = ref.watch(supervisionRepositoryProvider);
    final product = invRepo.getNationalProduct(productId);
    if (product == null) return const Center(child: Text('Product not found'));

    final brands = invRepo.getBrandsByNationalId(product.id);
    var totalStock = 0;
    var nearExpiryCount = 0;
    final batchRows = <Map<String, dynamic>>[];
    for (final brand in brands) {
      final batches = invRepo.getBatchesByBrand(brand.id);
      for (final b in batches) {
        totalStock += b.quantity;
        if (b.expiryRisk == ExpiryRiskLevel.high || b.expiryRisk == ExpiryRiskLevel.medium) nearExpiryCount++;
        final loc = SeedData.stockLocations.where((l) => l.id == b.locationId).toList();
        batchRows.add({
          'batch': b,
          'brand': brand,
          'location': loc.isNotEmpty ? loc.first.name : b.locationId,
        });
      }
    }
    batchRows.sort((a, b) => (a['batch'] as StockBatch).expiryDate.compareTo((b['batch'] as StockBatch).expiryDate));
    final demandSignals = supRepo.getDemandSignalsByLocation('pharm-er-b').where((d) => d.productNationalId == productId).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${product.name} ${product.form}', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            children: [
              StatusChip(label: 'Total: $totalStock', statusType: StatusChipType.neutral),
              if (nearExpiryCount > 0) StatusChip(label: '$nearExpiryCount near expiry', statusType: StatusChipType.warning),
              if (demandSignals.isNotEmpty) StatusChip(label: 'Demand signal', statusType: StatusChipType.danger),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionCard(
            title: 'Brands & batches',
            child: batchRows.isEmpty
                ? const Text('No stock')
                : Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: AppColors.surfaceVariant),
                        children: [
                          _th(context, 'Brand'),
                          _th(context, 'Batch number'),
                          _th(context, 'Location'),
                          _th(context, 'Qty'),
                          _th(context, 'Expiry'),
                        ],
                      ),
                      ...batchRows.map((r) {
                        final b = r['batch'] as StockBatch;
                        final brand = r['brand'] as ProductBrand;
                        final loc = r['location'] as String;
                        return TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.all(8), child: Text(brand.brandName)),
                            Padding(padding: const EdgeInsets.all(8), child: Text(b.batchNumber)),
                            Padding(padding: const EdgeInsets.all(8), child: Text(loc)),
                            Padding(padding: const EdgeInsets.all(8), child: Text('${b.quantity}')),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text(DateFormat.yMd().format(b.expiryDate)),
                                  const SizedBox(width: 4),
                                  StatusChip(label: b.expiryRisk.label, size: StatusChipSize.small, statusType: b.expiryRisk == ExpiryRiskLevel.high ? StatusChipType.danger : b.expiryRisk == ExpiryRiskLevel.medium ? StatusChipType.warning : StatusChipType.neutral),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _th(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
