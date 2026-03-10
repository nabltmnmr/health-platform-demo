import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/enums/enums.dart';
import '../../../core/models/models.dart';
import '../../../core/repositories/nursing_repository.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/repositories/encounter_repository.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/utils/queue_location_helper.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/empty_state.dart';

class NursingQueueScreen extends ConsumerStatefulWidget {
  const NursingQueueScreen({super.key});

  @override
  ConsumerState<NursingQueueScreen> createState() => _NursingQueueScreenState();
}

class _NursingQueueScreenState extends ConsumerState<NursingQueueScreen> {
  final _searchController = TextEditingController();
  String? _selectedNursingAreaId; // null = All

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nursingRepo = ref.watch(nursingRepositoryProvider);
    final patientRepo = ref.watch(patientRepositoryProvider);
    final encounterRepo = ref.watch(encounterRepositoryProvider);
    final ticketRepo = ref.watch(ticketRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final query = _searchController.text.trim().toLowerCase();

    var orders = nursingRepo.allOrders.where((o) => o.status != TreatmentStatus.administered).toList();
    if (query.isNotEmpty) {
      orders = orders.where((o) {
        final name = patientRepo.getById(o.patientId)?.name ?? '';
        return name.toLowerCase().contains(query);
      }).toList();
    }
    // Filter by selected nursing queue (area)
    final nursingAreas = SeedData.nursingAreas;
    if (_selectedNursingAreaId != null) {
      final selected = nursingAreas.where((a) => a.id == _selectedNursingAreaId).toList();
      if (selected.isNotEmpty) {
        final deptId = selected.first.departmentId;
        orders = orders.where((o) => getDepartmentIdForEncounter(o.encounterId, encounterRepo, ticketRepo) == deptId).toList();
      }
    }

    final byCategory = <QueueLocationCategory, List<TreatmentOrder>>{
      QueueLocationCategory.er: [],
      QueueLocationCategory.clinics: [],
      QueueLocationCategory.wards: [],
    };
    for (final o in orders) {
      final cat = getQueueLocationCategory(o.encounterId, encounterRepo, ticketRepo);
      byCategory[cat]!.add(o);
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.nursingQueueTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l10n.all),
                    selected: _selectedNursingAreaId == null,
                    onSelected: (_) => setState(() => _selectedNursingAreaId = null),
                    selectedColor: AppColors.primaryContainer,
                  ),
                ),
                ...nursingAreas.map((a) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(a.name),
                    selected: _selectedNursingAreaId == a.id,
                    onSelected: (_) => setState(() => _selectedNursingAreaId = a.id),
                    selectedColor: AppColors.primaryContainer,
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.searchByPatientName,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: orders.isEmpty
                ? EmptyState(
                    icon: Icons.medication_liquid,
                    title: query.isEmpty ? l10n.noPendingTreatments : l10n.noMatchingPatients,
                  )
                : ListView(
                    children: [
                      for (final category in QueueLocationCategory.values)
                        if (byCategory[category]!.isNotEmpty) ...[
                          SectionCard(
                            title: '${l10n.queueLocationCategoryLabel(category)} — ${l10n.dueTreatments} (${byCategory[category]!.length})',
                            expandChild: true,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: byCategory[category]!.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (_, i) {
                                final o = byCategory[category]![i];
                                final patient = patientRepo.getById(o.patientId);
                                return ListTile(
                                  title: Text(o.description),
                                  subtitle: Text(
                                    '${patient?.name ?? o.patientId} — Due ${DateFormat.Hm().format(o.dueAt)}${(o.medicationDispensed ?? false) ? ' · Dispensed' : ''}',
                                  ),
                                  trailing: StatusChip(label: o.status.label, size: StatusChipSize.small),
                                  onTap: () => context.push('/nursing/administer/${o.id}'),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
