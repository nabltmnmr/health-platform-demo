import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/hero_dashboard_card.dart';

class InventoryDashboardScreen extends ConsumerWidget {
  const InventoryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final pendingCount = invRepo.getPendingSupplyRequests().length;
    var lowStockCount = 0;
    final nearExpiryPids = <String>{};
    for (final p in invRepo.nationalProducts) {
      var total = 0;
      for (final b in invRepo.allBatches) {
        final brandList = invRepo.brands.where((x) => x.id == b.productBrandId).toList();
        if (brandList.isNotEmpty && brandList.first.productNationalId == p.id) {
          total += b.quantity;
          if (b.expiryRisk.index >= 2) nearExpiryPids.add(p.id);
        }
      }
      if (total > 0 && total < 50) lowStockCount++;
    }
    final nearExpiryCount = nearExpiryPids.length;
    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text(l10n.inventoryDashboardTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.inventoryDashboardSubtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= Breakpoints.tablet;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              MetricCard(title: l10n.lowStockAlerts, value: '$lowStockCount', icon: Icons.warning_amber_rounded, onTap: () => context.push('/supply/analytics?type=lowStock')),
                              const SizedBox(height: AppSpacing.md),
                              MetricCard(title: l10n.nearExpiry, value: '$nearExpiryCount', icon: Icons.schedule),
                              const SizedBox(height: AppSpacing.md),
                              MetricCard(title: l10n.pendingRequests, value: '$pendingCount', icon: Icons.inbox),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            children: [
                              HeroDashboardCard(
                                title: l10n.productList,
                                subtitle: l10n.productListSubtitle,
                                icon: Icons.inventory_2,
                                onTap: () => context.push('/supply/products'),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              HeroDashboardCard(
                                title: l10n.supplyRequests,
                                subtitle: l10n.supplyRequestsSubtitle,
                                icon: Icons.local_shipping,
                                onTap: () => context.push('/supply/requests'),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              HeroDashboardCard(
                                title: l10n.receiveSupply,
                                subtitle: l10n.receiveSupplySubtitle,
                                icon: Icons.add_box,
                                onTap: () => context.push('/supply/receive'),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              HeroDashboardCard(
                                title: l10n.receivedSupplies,
                                subtitle: l10n.receivedSuppliesSubtitle,
                                icon: Icons.receipt_long,
                                onTap: () => context.push('/supply/receipts'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        MetricCard(title: l10n.lowStockAlerts, value: '$lowStockCount', icon: Icons.warning_amber_rounded),
                        const SizedBox(height: AppSpacing.md),
                        MetricCard(title: l10n.nearExpiry, value: '$nearExpiryCount', icon: Icons.schedule),
                        const SizedBox(height: AppSpacing.md),
                        MetricCard(title: l10n.pendingRequests, value: '$pendingCount', icon: Icons.inbox),
                        const SizedBox(height: AppSpacing.xl),
                        HeroDashboardCard(title: l10n.productList, subtitle: l10n.productListSubtitle, icon: Icons.inventory_2, onTap: () => context.push('/supply/products')),
                        const SizedBox(height: AppSpacing.md),
                        HeroDashboardCard(title: l10n.supplyRequests, subtitle: l10n.supplyRequestsSubtitle, icon: Icons.local_shipping, onTap: () => context.push('/supply/requests')),
                        const SizedBox(height: AppSpacing.md),
                        HeroDashboardCard(title: l10n.receiveSupply, subtitle: l10n.receiveSupplySubtitle, icon: Icons.add_box, onTap: () => context.push('/supply/receive')),
                        const SizedBox(height: AppSpacing.md),
                        HeroDashboardCard(title: l10n.receivedSupplies, subtitle: l10n.receivedSuppliesSubtitle, icon: Icons.receipt_long, onTap: () => context.push('/supply/receipts')),
                      ],
                    );
            },
          ),
        ],
      ),
    ));
  }
}
