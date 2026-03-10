import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../core/repositories/queue_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/enums/enums.dart';
import '../../../core/models/models.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/queue_row.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/section_card.dart';

class QueueScreen extends ConsumerStatefulWidget {
  const QueueScreen({super.key});

  @override
  ConsumerState<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends ConsumerState<QueueScreen> {
  String _selectedAreaId = '';

  @override
  void initState() {
    super.initState();
    final areas = _getClinicAreas();
    if (areas.isNotEmpty && _selectedAreaId.isEmpty) {
      _selectedAreaId = areas.first.id;
    }
  }

  List<ClinicArea> _getClinicAreas() {
    final facilityId = ref.read(currentUserProvider)?.facilityId ?? 'hosp-a';
    return SeedData.clinicAreas
        .where((c) {
          for (final d in SeedData.departments) {
            if (d.facilityId == facilityId && d.clinicAreaIds.contains(c.id)) return true;
          }
          return false;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final queueRepo = ref.watch(queueRepositoryProvider);
    final patientRepo = ref.watch(patientRepositoryProvider);
    final ticketRepo = ref.watch(ticketRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final areas = _getClinicAreas();

    if (areas.isEmpty) {
      return Center(child: Text(l10n.noClinicAreas));
    }

    if (_selectedAreaId.isEmpty) _selectedAreaId = areas.first.id;

    final entries = queueRepo.getByArea(_selectedAreaId);
    final areaName = areas.firstWhere((a) => a.id == _selectedAreaId, orElse: () => areas.first).name;

    return PageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.queueTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: areas
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(a.name),
                          selected: _selectedAreaId == a.id,
                          onSelected: (_) => setState(() => _selectedAreaId = a.id),
                          selectedColor: AppColors.primaryContainer,
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: SectionCard(
              title: areaName,
              expandChild: true,
              child: entries.isEmpty
                  ? EmptyState(
                      icon: Icons.queue_play_next,
                      title: l10n.queueEmpty,
                      message: l10n.noPatientsInQueue,
                    )
                  : ListView.separated(
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final e = entries[i];
                        final patient = patientRepo.getById(e.patientId);
                        final ticket = ticketRepo.getById(e.ticketId);
                        return QueueRow(
                          queueNumber: e.queueNumber,
                          patientName: patient?.name ?? 'Unknown',
                          statusLabel: l10n.queueStatusLabel(e.status),
                          onTap: () => context.push('/tickets/${e.ticketId}'),
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
