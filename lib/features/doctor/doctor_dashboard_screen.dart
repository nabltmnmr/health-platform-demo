import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../core/enums/enums.dart';
import '../../../core/repositories/encounter_repository.dart';
import '../../../core/repositories/lab_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/hero_dashboard_card.dart';

class DoctorDashboardScreen extends ConsumerWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilityId = ref.watch(selectedFacilityIdProvider) ?? 'hosp-a';
    final ticketRepo = ref.watch(ticketRepositoryProvider);
    final encounterRepo = ref.watch(encounterRepositoryProvider);
    final labRepo = ref.watch(labRepositoryProvider);

    final tickets = ticketRepo.getByFacility(facilityId);
    final inProgress = tickets.where((t) => t.status == VisitStatus.inProgress).toList();
    final queued = tickets.where((t) => t.status == VisitStatus.queued).toList();
    final pendingLabs = labRepo.allRequests.where((r) => r.status != LabRequestStatus.completed).toList();

    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Doctor Dashboard', style: Theme.of(context).textTheme.headlineSmall),
          Builder(
            builder: (context) {
              final user = ref.watch(currentUserProvider);
              final facilityName = user?.facilityId == 'hosp-a'
                  ? 'Al-Rashid General Hospital'
                  : user?.facilityId == 'hosp-b'
                      ? 'Al-Zahra Medical Center'
                      : user?.facilityId == 'hosp-c'
                          ? 'Northern Regional Hospital'
                          : null;
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  user != null && facilityName != null
                      ? 'Viewing as ${user.displayName} • $facilityName'
                      : 'Your facility at a glance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= Breakpoints.mobile;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _metricsColumn(context, inProgress, queued, pendingLabs)),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: _actionsColumn(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _metricsColumn(context, inProgress, queued, pendingLabs),
                        const SizedBox(height: AppSpacing.xl),
                        _actionsColumn(context),
                      ],
                    );
            },
          ),
        ],
      ),
    ));
  }

  Widget _metricsColumn(BuildContext context, List inProgress, List queued, List pendingLabs) {
    return Column(
      children: [
        MetricCard(title: 'In progress', value: '${inProgress.length}', icon: Icons.person_pin),
        const SizedBox(height: AppSpacing.md),
        MetricCard(title: 'Queued', value: '${queued.length}', icon: Icons.queue),
        const SizedBox(height: AppSpacing.md),
        MetricCard(title: 'Pending labs', value: '${pendingLabs.length}', icon: Icons.science),
      ],
    );
  }

  Widget _actionsColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeroDashboardCard(
          title: 'Queue',
          subtitle: 'View and call patients',
          icon: Icons.queue_play_next,
          onTap: () => context.push('/queue'),
        ),
        const SizedBox(height: AppSpacing.md),
        HeroDashboardCard(
          title: 'Start encounter',
          subtitle: 'Open encounter from ticket',
          icon: Icons.medical_information,
          onTap: () => context.push('/queue'),
        ),
      ],
    );
  }
}
