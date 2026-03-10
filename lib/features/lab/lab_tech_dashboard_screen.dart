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

/// Dashboard for Lab Technician: incoming tests, pending, completed.
class LabTechDashboardScreen extends ConsumerWidget {
  const LabTechDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labRepo = ref.watch(labRepositoryProvider);
    final pending = labRepo.allRequests.where((r) => r.status != LabRequestStatus.completed).toList();
    final completed = labRepo.allRequests.where((r) => r.status == LabRequestStatus.completed).toList();
    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Lab Dashboard', style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'Incoming tests and results',
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
                                MetricCard(title: 'Pending tests', value: '${pending.length}', icon: Icons.pending_actions),
                                const SizedBox(height: AppSpacing.md),
                                MetricCard(title: 'Completed today', value: '${completed.length}', icon: Icons.check_circle),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: HeroDashboardCard(
                              title: 'Lab queue',
                              subtitle: 'View and complete tests',
                              icon: Icons.science,
                              onTap: () => context.push('/lab'),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          MetricCard(title: 'Pending tests', value: '${pending.length}', icon: Icons.pending_actions),
                          const SizedBox(height: AppSpacing.md),
                          HeroDashboardCard(title: 'Lab queue', subtitle: 'View and complete tests', icon: Icons.science, onTap: () => context.push('/lab')),
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
