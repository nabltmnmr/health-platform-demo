import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_chip.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key, this.analyticsType});

  final String? analyticsType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final type = analyticsType ?? 'lowStock';

    final lowStock = <Map<String, dynamic>>[];
    final nearExpiry = <Map<String, dynamic>>[];
    final overstock = <Map<String, dynamic>>[];

    for (final p in invRepo.nationalProducts) {
      var totalByLoc = <String, int>{};
      var nearExpiryByLoc = <String, int>{};
      for (final loc in SeedData.stockLocations) {
        final batches = invRepo.getBatchesForNationalProductAtLocation(p.id, loc.id);
        var total = 0;
        var near = 0;
        for (final b in batches) {
          total += b.quantity;
          if (b.expiryRisk == ExpiryRiskLevel.high || b.expiryRisk == ExpiryRiskLevel.medium) near += b.quantity;
        }
        totalByLoc[loc.id] = total;
        nearExpiryByLoc[loc.id] = near;
      }
      final grandTotal = totalByLoc.values.fold<int>(0, (a, b) => a + b);
      if (grandTotal > 0 && grandTotal < 50) lowStock.add({'product': p, 'total': grandTotal});
      final nearTotal = nearExpiryByLoc.values.fold<int>(0, (a, b) => a + b);
      if (nearTotal > 0) nearExpiry.add({'product': p, 'quantity': nearTotal});
      if (grandTotal > 500) overstock.add({'product': p, 'total': grandTotal});
    }

    List<Map<String, dynamic>> items = [];
    String title = '';
    if (type == 'lowStock') {
      items = lowStock;
      title = 'Low stock';
    } else if (type == 'nearExpiry') {
      items = nearExpiry;
      title = 'Near expiry';
    } else if (type == 'overstock') {
      items = overstock;
      title = 'Overstock';
    }

    return PageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(label: const Text('Low stock'), selected: type == 'lowStock', onSelected: (_) => context.go('/supply/analytics?type=lowStock')),
              ChoiceChip(label: const Text('Near expiry'), selected: type == 'nearExpiry', onSelected: (_) => context.go('/supply/analytics?type=nearExpiry')),
              ChoiceChip(label: const Text('Overstock'), selected: type == 'overstock', onSelected: (_) => context.go('/supply/analytics?type=overstock')),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: SectionCard(
              title: title,
              expandChild: true,
              child: items.isEmpty
                  ? const Center(child: Text('No items'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final m = items[i];
                        final p = m['product'] as ProductNationalIdentifier;
                        return ListTile(
                          title: Text('${p.name} ${p.form}'),
                          subtitle: type == 'nearExpiry' ? null : Text('Total: ${m['total'] ?? m['quantity']}'),
                          trailing: type == 'lowStock'
                              ? StatusChip(label: 'Low', statusType: StatusChipType.danger, size: StatusChipSize.small)
                              : type == 'nearExpiry'
                                  ? StatusChip(label: 'At risk', statusType: StatusChipType.warning, size: StatusChipSize.small)
                                  : StatusChip(label: 'Over', statusType: StatusChipType.warning, size: StatusChipSize.small),
                          onTap: () => context.push('/supply/product/${p.id}'),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
