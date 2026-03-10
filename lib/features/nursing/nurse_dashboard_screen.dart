import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/enums/enums.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/hero_dashboard_card.dart';

/// Dashboard for Nurse: due treatments, pending administrations.
class NurseDashboardScreen extends ConsumerWidget {
  const NurseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nursingRepo = ref.watch(nursingRepositoryProvider);
    final pending = nursingRepo.allOrders.where((o) => o.status != TreatmentStatus.administered).toList();
    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nursing Dashboard', style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'Due treatments and administrations',
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
                            child: MetricCard(title: 'Pending treatments', value: '${pending.length}', icon: Icons.medication_liquid),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: HeroDashboardCard(
                              title: 'Nursing queue',
                              subtitle: 'View and administer treatments',
                              icon: Icons.medical_services,
                              onTap: () => context.push('/nursing'),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          MetricCard(title: 'Pending treatments', value: '${pending.length}', icon: Icons.medication_liquid),
                          const SizedBox(height: AppSpacing.md),
                          HeroDashboardCard(title: 'Nursing queue', subtitle: 'Administer treatments', icon: Icons.medical_services, onTap: () => context.push('/nursing')),
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
