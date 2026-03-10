import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/enums/enums.dart';
import '../../../core/models/models.dart';
import '../../../core/repositories/lab_repository.dart';
import '../../../core/repositories/encounter_repository.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/utils/queue_location_helper.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/empty_state.dart';

class LabQueueScreen extends ConsumerStatefulWidget {
  const LabQueueScreen({super.key});

  @override
  ConsumerState<LabQueueScreen> createState() => _LabQueueScreenState();
}

class _LabQueueScreenState extends ConsumerState<LabQueueScreen> {
  final _searchController = TextEditingController();
  String? _selectedLabAreaId; // null = All

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labRepo = ref.watch(labRepositoryProvider);
    final patientRepo = ref.watch(patientRepositoryProvider);
    final encounterRepo = ref.watch(encounterRepositoryProvider);
    final ticketRepo = ref.watch(ticketRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final query = _searchController.text.trim().toLowerCase();

    var requests = labRepo.allRequests.where((r) => r.status != LabRequestStatus.completed).toList();
    if (query.isNotEmpty) {
      requests = requests.where((r) {
        final name = patientRepo.getById(r.patientId)?.name ?? '';
        return name.toLowerCase().contains(query);
      }).toList();
    }
    // Filter by selected lab queue (area)
    final labAreas = SeedData.labAreas;
    if (_selectedLabAreaId != null) {
      final selected = labAreas.where((a) => a.id == _selectedLabAreaId).toList();
      if (selected.isNotEmpty) {
        final deptId = selected.first.departmentId;
        requests = requests.where((r) => getDepartmentIdForEncounter(r.encounterId, encounterRepo, ticketRepo) == deptId).toList();
      }
    }

    final byCategory = <QueueLocationCategory, List<LabRequest>>{
      QueueLocationCategory.er: [],
      QueueLocationCategory.clinics: [],
      QueueLocationCategory.wards: [],
    };
    for (final r in requests) {
      final cat = getQueueLocationCategory(r.encounterId, encounterRepo, ticketRepo);
      byCategory[cat]!.add(r);
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.labQueueTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l10n.all),
                    selected: _selectedLabAreaId == null,
                    onSelected: (_) => setState(() => _selectedLabAreaId = null),
                    selectedColor: AppColors.primaryContainer,
                  ),
                ),
                ...labAreas.map((a) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(a.name),
                    selected: _selectedLabAreaId == a.id,
                    onSelected: (_) => setState(() => _selectedLabAreaId = a.id),
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
            child: requests.isEmpty
                ? EmptyState(
                    icon: Icons.science,
                    title: query.isEmpty ? l10n.noPendingTests : l10n.noMatchingPatients,
                  )
                : ListView(
                    children: [
                      for (final category in QueueLocationCategory.values)
                        if (byCategory[category]!.isNotEmpty) ...[
                          SectionCard(
                            title: '${l10n.queueLocationCategoryLabel(category)} (${byCategory[category]!.length})',
                            expandChild: true,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: byCategory[category]!.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (_, i) {
                                final r = byCategory[category]![i];
                                final patient = patientRepo.getById(r.patientId);
                                return ListTile(
                                  title: Text(r.testName),
                                  subtitle: Text(patient?.name ?? r.patientId),
                                  trailing: StatusChip(label: r.status.label, size: StatusChipSize.small),
                                  onTap: () => context.push('/lab/result/${r.id}'),
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
