import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/repositories/pharmacy_repository.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/empty_state.dart';

class PharmacyQueueScreen extends ConsumerStatefulWidget {
  const PharmacyQueueScreen({super.key});

  @override
  ConsumerState<PharmacyQueueScreen> createState() => _PharmacyQueueScreenState();
}

class _PharmacyQueueScreenState extends ConsumerState<PharmacyQueueScreen> {
  String _areaId = 'pharm-er-a';

  @override
  void initState() {
    super.initState();
    final facilityId = ref.read(currentUserProvider)?.facilityId ?? 'hosp-a';
    final areas = SeedData.pharmacyAreas.where((a) {
      for (final d in SeedData.departments) {
        if (d.facilityId == facilityId && d.pharmacyAreaIds.contains(a.id)) return true;
      }
      return false;
    }).toList();
    if (areas.isNotEmpty) _areaId = areas.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyRepo = ref.watch(pharmacyRepositoryProvider);
    final patientRepo = ref.watch(patientRepositoryProvider);
    final facilityId = ref.watch(currentUserProvider)?.facilityId ?? 'hosp-a';
    final areas = SeedData.pharmacyAreas.where((a) {
      for (final d in SeedData.departments) {
        if (d.facilityId == facilityId && d.pharmacyAreaIds.contains(a.id)) return true;
      }
      return false;
    }).toList();
    if (_areaId.isEmpty && areas.isNotEmpty) _areaId = areas.first.id;

    final pending = pharmacyRepo.getPendingByPharmacyArea(_areaId);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Pharmacy Queue', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: areas.map((a) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(a.name),
                  selected: _areaId == a.id,
                  onSelected: (_) => setState(() => _areaId = a.id),
                  selectedColor: AppColors.primaryContainer,
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: SectionCard(
              title: 'Pending prescriptions',
              expandChild: true,
              child: pending.isEmpty
                  ? const EmptyState(icon: Icons.medication, title: 'No pending prescriptions')
                  : ListView.separated(
                      itemCount: pending.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final rx = pending[i];
                        final patient = patientRepo.getById(rx.patientId);
                        return ListTile(
                          title: Text(patient?.name ?? rx.patientId),
                          subtitle: Text('${rx.items.length} item(s)'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                          onTap: () => context.push('/pharmacy/dispense/${rx.id}'),
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
