import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../app/theme/radii.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/empty_state.dart';

class PatientSearchScreen extends ConsumerStatefulWidget {
  const PatientSearchScreen({super.key});

  @override
  ConsumerState<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends ConsumerState<PatientSearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientRepo = ref.watch(patientRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final patients = _query.isEmpty
        ? patientRepo.all
        : patientRepo.searchByName(_query);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppSearchBar(
                  controller: _controller,
                  hint: l10n.searchByPatientName,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              FilledButton.icon(
                onPressed: () => context.push('/patients/new'),
                icon: const Icon(Icons.add),
                label: Text(l10n.newPatient),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: patients.isEmpty
                ? EmptyState(
                    title: _query.isEmpty ? l10n.noPatients : l10n.noMatches,
                    message: _query.isEmpty
                        ? l10n.createPatientToGetStarted
                        : l10n.tryDifferentSearch,
                    action: _query.isEmpty
                        ? FilledButton.icon(
                            onPressed: () => context.push('/patients/new'),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.createPatient),
                          )
                        : null,
                  )
                : ListView.separated(
                    itemCount: patients.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final p = patients[i];
                      return Material(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        child: InkWell(
                          onTap: () => context.push('/tickets/new?patientId=${p.id}'),
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryContainer,
                                  child: Text(p.name.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(color: AppColors.onPrimaryContainer)),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name, style: Theme.of(context).textTheme.titleSmall),
                                      if (p.medicalRecordNumber != null)
                                        Text('MRN: ${p.medicalRecordNumber}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                if (p.ageYears != null)
                                  Text('${p.ageYears} yrs',
                                      style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(width: AppSpacing.sm),
                                Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
