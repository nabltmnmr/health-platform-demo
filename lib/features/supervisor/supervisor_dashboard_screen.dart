import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/enums/enums.dart';
import '../../../core/models/models.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/recommendation_card.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/hero_dashboard_card.dart';

class SupervisorDashboardScreen extends ConsumerWidget {
  const SupervisorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supRepo = ref.watch(supervisionRepositoryProvider);
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final suggestions = supRepo.transferSuggestions;

    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Supervisor dashboard', style: Theme.of(context).textTheme.headlineSmall),
          Builder(
            builder: (context) {
              final user = ref.watch(currentUserProvider);
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  user != null
                      ? 'Viewing as ${user.displayName} • Stock balance across Central & Northern Health'
                      : 'Institute comparison, analytics, and AI recommendations',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
              );
            },
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
                          flex: 2,
                          child: Column(
                            children: [
                              _buildMetrics(context, invRepo, supRepo),
                              const SizedBox(height: AppSpacing.xl),
                              _buildQuickActions(context),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          flex: 3,
                          child: _buildRecommendations(context, suggestions, invRepo),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildMetrics(context, invRepo, supRepo),
                        const SizedBox(height: AppSpacing.xl),
                        _buildQuickActions(context),
                        const SizedBox(height: AppSpacing.xl),
                        _buildRecommendations(context, suggestions, invRepo),
                      ],
                    );
            },
          ),
        ],
      ),
    ));
  }

  Widget _buildMetrics(BuildContext context, dynamic invRepo, dynamic supRepo) {
    var lowStockCount = 0;
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
    }
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        MetricCard(title: 'Transfer recommendations', value: '${supRepo.transferSuggestions.length}', icon: Icons.swap_horiz, onTap: () => context.push('/supply/recommendations')),
        MetricCard(title: 'Demand signals', value: '${supRepo.demandSignals.length}', icon: Icons.signal_cellular_alt),
        MetricCard(title: 'Low stock items', value: '$lowStockCount', icon: Icons.warning_amber_rounded, onTap: () => context.push('/supply/analytics?type=lowStock')),
        MetricCard(title: 'Near expiry', value: '${nearExpiryPids.length}', icon: Icons.schedule, onTap: () => context.push('/supply/analytics?type=nearExpiry')),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeroDashboardCard(
          title: 'Institute comparison',
          subtitle: 'Compare stock across institutes',
          icon: Icons.compare_arrows,
          onTap: () => context.push('/supply/comparison'),
        ),
        const SizedBox(height: AppSpacing.md),
        HeroDashboardCard(
          title: 'Transfer recommendations',
          subtitle: 'AI redistribution suggestions',
          icon: Icons.auto_awesome,
          onTap: () => context.push('/supply/recommendations'),
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context, List<TransferSuggestion> suggestions, invRepo) {
    return SectionCard(
      title: 'Top recommendations',
      child: suggestions.isEmpty
          ? const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No recommendations')))
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
                      if (t.shortageRelief) 'Shortage relief',
                      if (t.expiryPrevention) 'Expiry prevention',
                    ],
                    urgency: t.priority.label,
                    wastePrevented: t.estimatedWastePrevented,
                    onTap: () => context.push('/supply/transfer/${t.id}'),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
