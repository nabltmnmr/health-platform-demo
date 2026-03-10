import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/enums/enums.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/hero_dashboard_card.dart';

/// Dashboard for Registration Clerk: patient lookup, new ticket, queues.
class RegistrationDashboardScreen extends ConsumerWidget {
  const RegistrationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketRepo = ref.watch(ticketRepositoryProvider);
    final facilityId = ref.watch(selectedFacilityIdProvider) ?? 'hosp-a';
    final tickets = ticketRepo.getByFacility(facilityId);
    final active = tickets.where((t) => t.status == VisitStatus.inProgress || t.status == VisitStatus.queued).toList();
    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Registration', style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'Patient lookup, tickets, and queues',
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
                                MetricCard(title: 'Active visits', value: '${active.length}', icon: Icons.person_pin_circle),
                                const SizedBox(height: AppSpacing.md),
                                MetricCard(title: 'Today\'s tickets', value: '${tickets.length}', icon: Icons.confirmation_number),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                HeroDashboardCard(
                                  title: 'Patient search',
                                  subtitle: 'Search or create patient',
                                  icon: Icons.person_search,
                                  onTap: () => context.push('/patients'),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                HeroDashboardCard(
                                  title: 'New ticket',
                                  subtitle: 'Create visit ticket',
                                  icon: Icons.add_circle_outline,
                                  onTap: () => context.push('/tickets/new'),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                HeroDashboardCard(
                                  title: 'Queue',
                                  subtitle: 'View queue by area',
                                  icon: Icons.queue_play_next,
                                  onTap: () => context.push('/queue'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          MetricCard(title: 'Active visits', value: '${active.length}', icon: Icons.person_pin_circle),
                          const SizedBox(height: AppSpacing.md),
                          HeroDashboardCard(title: 'Patient search', subtitle: 'Search or create', icon: Icons.person_search, onTap: () => context.push('/patients')),
                          const SizedBox(height: AppSpacing.md),
                          HeroDashboardCard(title: 'New ticket', subtitle: 'Create visit ticket', icon: Icons.add_circle_outline, onTap: () => context.push('/tickets/new')),
                          const SizedBox(height: AppSpacing.md),
                          HeroDashboardCard(title: 'Queue', subtitle: 'View by area', icon: Icons.queue_play_next, onTap: () => context.push('/queue')),
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
