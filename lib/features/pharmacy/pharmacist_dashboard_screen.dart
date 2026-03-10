import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/enums/enums.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/hero_dashboard_card.dart';

/// Dashboard for Pharmacist: pending prescriptions, low stock, FEFO alerts.
class PharmacistDashboardScreen extends ConsumerWidget {
  const PharmacistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmacyRepo = ref.watch(pharmacyRepositoryProvider);
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final pending = pharmacyRepo.allPrescriptions.where((p) => p.status == PrescriptionStatus.pending).toList();
    int lowStockCount = 0;
    for (final p in invRepo.nationalProducts) {
      final brandIds = invRepo.getBrandsByNationalId(p.id).map((b) => b.id).toSet();
      final total = invRepo.allBatches
          .where((b) => brandIds.contains(b.productBrandId))
          .fold<int>(0, (s, b) => s + b.quantity);
      if (total < 50) lowStockCount++;
    }
    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.pharmacyDashboardTitle, style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.pharmacyDashboardSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= Breakpoints.mobile;
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                MetricCard(title: l10n.pendingPrescriptions, value: '${pending.length}', icon: Icons.medication, onTap: () => context.push('/pharmacy')),
                                const SizedBox(height: AppSpacing.md),
                                MetricCard(title: l10n.lowStockItems, value: '$lowStockCount', icon: Icons.warning_amber_rounded),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                HeroDashboardCard(
                                  title: l10n.prescriptionQueue,
                                  subtitle: l10n.prescriptionQueueSubtitle,
                                  icon: Icons.medication_liquid,
                                  onTap: () => context.push('/pharmacy'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          MetricCard(title: l10n.pendingPrescriptions, value: '${pending.length}', icon: Icons.medication, onTap: () => context.push('/pharmacy')),
                          const SizedBox(height: AppSpacing.md),
                          HeroDashboardCard(title: l10n.prescriptionQueue, subtitle: l10n.dispensePending, icon: Icons.medication_liquid, onTap: () => context.push('/pharmacy')),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
