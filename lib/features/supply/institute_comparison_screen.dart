import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/section_card.dart';

class InstituteComparisonScreen extends ConsumerWidget {
  const InstituteComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invRepo = ref.watch(inventoryRepositoryProvider);

    final rows = <_ComparisonRow>[];
    for (final p in invRepo.nationalProducts.take(6)) {
      for (final inst in SeedData.institutes) {
        var total = 0;
        for (final hosp in SeedData.hospitals.where((h) => h.instituteId == inst.id)) {
          for (final loc in SeedData.stockLocations.where((l) => l.facilityId == hosp.id)) {
            total += invRepo.getBatchesForNationalProductAtLocation(p.id, loc.id).fold<int>(0, (s, b) => s + b.quantity);
          }
        }
        for (final hc in SeedData.healthCenters.where((h) => h.instituteId == inst.id)) {
          for (final loc in SeedData.stockLocations.where((l) => l.facilityId == hc.id)) {
            total += invRepo.getBatchesForNationalProductAtLocation(p.id, loc.id).fold<int>(0, (s, b) => s + b.quantity);
          }
        }
        // Institute-level locations (e.g. DRUG DEPOT with facilityId == inst.id)
        for (final loc in SeedData.stockLocations.where((l) => l.facilityId == inst.id)) {
          total += invRepo.getBatchesForNationalProductAtLocation(p.id, loc.id).fold<int>(0, (s, b) => s + b.quantity);
        }
        rows.add(_ComparisonRow(
          productName: '${p.name} ${p.form}',
          instituteName: inst.name,
          totalStock: total,
          lowStock: total > 0 && total < 50,
          overstock: total > 400,
        ));
      }
    }

    return PageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Institute comparison', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Stock by national identifier across institutes', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: SectionCard(
              title: 'Stock by institute',
              expandChild: true,
              child: rows.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Text('No stock data. Add products and receive supply at institute locations.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
                      ),
                    )
                  : DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: [
                        DataColumn2(label: Text('Product', style: Theme.of(context).textTheme.labelLarge), size: ColumnSize.L),
                        DataColumn2(label: Text('Institute', style: Theme.of(context).textTheme.labelLarge)),
                        DataColumn2(label: Text('Stock', style: Theme.of(context).textTheme.labelLarge)),
                        DataColumn2(label: Text('Status', style: Theme.of(context).textTheme.labelLarge)),
                      ],
                      rows: rows.map((r) => DataRow2(
                            cells: [
                              DataCell(Text(r.productName)),
                              DataCell(Text(r.instituteName)),
                              DataCell(Text('${r.totalStock}')),
                              DataCell(Text(r.lowStock ? 'Low' : r.overstock ? 'Overstock' : (r.totalStock == 0 ? '—' : 'OK'), style: TextStyle(color: r.lowStock ? AppColors.danger : r.overstock ? AppColors.warning : AppColors.success))),
                            ],
                          )).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow {
  _ComparisonRow({required this.productName, required this.instituteName, required this.totalStock, this.lowStock = false, this.overstock = false});
  final String productName;
  final String instituteName;
  final int totalStock;
  final bool lowStock;
  final bool overstock;
}
