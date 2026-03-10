import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../app/theme/radii.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/services/locale_provider.dart';
import '../../../core/l10n/app_localizations.dart';

/// Pick institute for the demo. Shown after login, before demo selector.
class InstituteSelectorScreen extends ConsumerWidget {
  const InstituteSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final institutes = ref.watch(institutesProvider);
    final selected = ref.watch(selectedInstituteProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.selectInstitute),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => toggleLocale(ref),
            tooltip: l10n.isAr ? 'English' : 'العربية',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.chooseInstituteForDemo,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                ...institutes.map((inst) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Material(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        elevation: selected?.id == inst.id ? 2 : 1,
                        shadowColor: AppColors.outline,
                        child: InkWell(
                          onTap: () {
                            ref.read(selectedInstituteProvider.notifier).state = inst;
                            context.go('/demo-selector');
                          },
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 40,
                                  color: selected?.id == inst.id ? AppColors.primary : AppColors.textSecondary,
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        inst.name,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: selected?.id == inst.id ? AppColors.primary : AppColors.textPrimary,
                                            ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        l10n.institutesSummary(inst.hospitalIds.length, inst.healthCenterIds.length),
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                if (selected?.id == inst.id)
                                  Icon(Icons.check_circle, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
