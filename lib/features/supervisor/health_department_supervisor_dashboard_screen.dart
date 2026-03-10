import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/enums/enums.dart';
import '../../../core/seed/seed_data.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/recommendation_card.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/hero_dashboard_card.dart';

/// Dashboard for Health Department Supervisor demo: supervise all institutes,
/// select institute, view overstock/understock/missing reports, compare, AI transfers.
class HealthDepartmentSupervisorDashboardScreen extends ConsumerWidget {
  const HealthDepartmentSupervisorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supRepo = ref.watch(supervisionRepositoryProvider);
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final institutes = ref.watch(institutesProvider);
    final selectedInstituteId = ref.watch(selectedSupervisorInstituteIdProvider);
    final l10n = ref.watch(appLocalizationsProvider);

    var lowStockCount = 0;
    var overstockCount = 0;
    final nearExpiryPids = <String>{};
    for (final p in invRepo.nationalProducts) {
      var total = 0;
      for (final b in invRepo.allBatches) {
        final brand = invRepo.brands.where((x) => x.id == b.productBrandId).toList();
        if (brand.isNotEmpty && brand.first.productNationalId == p.id) {
          total += b.quantity as int;
          if (b.expiryRisk == ExpiryRiskLevel.high || b.expiryRisk == ExpiryRiskLevel.medium) {
            nearExpiryPids.add(p.id);
          }
        }
      }
      if (total > 0 && total < 50) lowStockCount++;
      if (total >= 200) overstockCount++;
    }

    final suggestions = supRepo.transferSuggestions;

    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.healthDeptSupervisorTitle, style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.healthDeptSupervisorSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              value: selectedInstituteId,
              decoration: InputDecoration(
                labelText: l10n.selectInstitute,
                hintText: l10n.allInstitutes,
              ),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.allInstitutes)),
                ...institutes.map((i) => DropdownMenuItem(value: i.id, child: Text(i.name))),
              ],
              onChanged: (v) => ref.read(selectedSupervisorInstituteIdProvider.notifier).state = v,
            ),
            const SizedBox(height: AppSpacing.xl),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= Breakpoints.tablet;
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: AppSpacing.md,
                              runSpacing: AppSpacing.md,
                              children: [
                                MetricCard(
                                  title: l10n.understockItems,
                                  value: '$lowStockCount',
                                  icon: Icons.warning_amber_rounded,
                                  onTap: () => context.push('/supply/analytics?type=lowStock'),
                                ),
                                MetricCard(
                                  title: l10n.overstockItems,
                                  value: '$overstockCount',
                                  icon: Icons.inventory,
                                  onTap: () => context.push('/supply/analytics?type=overstock'),
                                ),
                                MetricCard(
                                  title: l10n.nearExpiry,
                                  value: '${nearExpiryPids.length}',
                                  icon: Icons.schedule,
                                  onTap: () => context.push('/supply/analytics?type=nearExpiry'),
                                ),
                                MetricCard(
                                  title: l10n.aiRecommendations,
                                  value: '${suggestions.length}',
                                  icon: Icons.auto_awesome,
                                  onTap: () => context.push('/supply/recommendations'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                HeroDashboardCard(
                                  title: l10n.compareInstitutes,
                                  subtitle: l10n.compareInstitutesSubtitle,
                                  icon: Icons.compare_arrows,
                                  onTap: () => context.push('/supply/comparison'),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                HeroDashboardCard(
                                  title: l10n.aiTransferRecommendations,
                                  subtitle: l10n.aiTransferRecommendationsSubtitle,
                                  icon: Icons.swap_horiz,
                                  onTap: () => context.push('/supply/recommendations'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            spacing: AppSpacing.md,
                            runSpacing: AppSpacing.md,
                            children: [
                              MetricCard(title: l10n.understockShort, value: '$lowStockCount', icon: Icons.warning_amber_rounded, onTap: () => context.push('/supply/analytics?type=lowStock')),
                              MetricCard(title: l10n.overstockShort, value: '$overstockCount', icon: Icons.inventory, onTap: () => context.push('/supply/analytics?type=overstock')),
                              MetricCard(title: l10n.nearExpiry, value: '${nearExpiryPids.length}', icon: Icons.schedule, onTap: () => context.push('/supply/analytics?type=nearExpiry')),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          HeroDashboardCard(
                            title: l10n.compareInstitutes,
                            subtitle: l10n.compareInstitutesSubtitleShort,
                            icon: Icons.compare_arrows,
                            onTap: () => context.push('/supply/comparison'),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          HeroDashboardCard(
                            title: l10n.aiTransferRecommendations,
                            subtitle: l10n.aiTransferRecommendationsSubtitleShort,
                            icon: Icons.swap_horiz,
                            onTap: () => context.push('/supply/recommendations'),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionCard(
              title: l10n.topAiRecommendations,
              child: suggestions.isEmpty
                  ? Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(l10n.noRecommendations)))
                  : Column(
                      children: suggestions.take(3).map<Widget>((t) {
                        final product = invRepo.getNationalProduct(t.productNationalId);
                        final sourceInst = SeedData.institutes.where((i) => i.id == t.sourceInstituteId).toList();
                        final destInst = SeedData.institutes.where((i) => i.id == t.destinationInstituteId).toList();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RecommendationCard(
                            productName: '${product?.name ?? t.productNationalId} ${product?.form ?? ''}',
                            summary: t.reasons.isNotEmpty ? t.reasons.first : '',
                            sourceName: sourceInst.isNotEmpty ? sourceInst.first.name : t.sourceInstituteId,
                            destinationName: destInst.isNotEmpty ? destInst.first.name : t.destinationInstituteId,
                            quantity: t.quantity,
                            reasonTags: [
                              if (t.shortageRelief) l10n.shortageRelief,
                              if (t.expiryPrevention) l10n.expiryPrevention,
                            ],
                            urgency: l10n.recommendationPriorityLabel(t.priority),
                            wastePrevented: t.estimatedWastePrevented,
                            wastePreventedLabel: t.estimatedWastePrevented != null ? l10n.estWastePrevented(t.estimatedWastePrevented!) : null,
                            quantityDisplay: '${l10n.quantityLabel}: ${t.quantity}',
                            onTap: () => context.push('/supply/transfer/${t.id}'),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
