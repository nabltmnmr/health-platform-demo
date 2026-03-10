import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/shadows.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/services/locale_provider.dart';
import '../../../core/l10n/app_localizations.dart';

class DemoSelectorScreen extends ConsumerWidget {
  const DemoSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.sizeOf(context).width >= Breakpoints.tablet;
    final l10n = ref.watch(appLocalizationsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.chooseDemo),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => toggleLocale(ref),
            tooltip: l10n.isAr ? 'English' : 'العربية',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: isDesktop
              ? IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DemoCard(
                        title: l10n.patientCareFlowTitle,
                        subtitle: l10n.patientCareFlowSubtitle,
                        hint: l10n.patientCareFlowHint,
                        icon: Icons.person_search,
                        onTap: () {
                          ref.read(selectedDemoModeProvider.notifier).state = DemoMode.patientCare;
                          context.go('/');
                        },
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      _DemoCard(
                        title: l10n.supplyFlowTitle,
                        subtitle: l10n.supplyFlowSubtitle,
                        hint: l10n.supplyFlowHint,
                        icon: Icons.inventory_2_outlined,
                        onTap: () {
                          ref.read(selectedDemoModeProvider.notifier).state = DemoMode.supplySupervision;
                          context.go('/');
                        },
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      _DemoCard(
                        title: l10n.healthDeptTitle,
                        subtitle: l10n.healthDeptSubtitle,
                        hint: l10n.healthDeptHint,
                        icon: Icons.supervisor_account,
                        onTap: () {
                          ref.read(selectedDemoModeProvider.notifier).state = DemoMode.healthDepartmentSupervisor;
                          context.go('/');
                        },
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DemoCard(
                      title: l10n.patientCareFlowTitle,
                      subtitle: l10n.patientCareFlowSubtitle,
                      hint: l10n.patientCareFlowHint,
                      icon: Icons.person_search,
                      onTap: () {
                        ref.read(selectedDemoModeProvider.notifier).state = DemoMode.patientCare;
                        context.go('/');
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _DemoCard(
                      title: l10n.supplyFlowTitle,
                      subtitle: l10n.supplyFlowSubtitle,
                      hint: l10n.supplyFlowHint,
                      icon: Icons.inventory_2_outlined,
                      onTap: () {
                        ref.read(selectedDemoModeProvider.notifier).state = DemoMode.supplySupervision;
                        context.go('/');
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _DemoCard(
                      title: l10n.healthDeptTitle,
                      subtitle: l10n.healthDeptSubtitle,
                      hint: l10n.healthDeptHint,
                      icon: Icons.supervisor_account,
                      onTap: () {
                        ref.read(selectedDemoModeProvider.notifier).state = DemoMode.healthDepartmentSupervisor;
                        context.go('/');
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.subtitle,
    this.hint,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? hint;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      shadowColor: AppShadows.card.first.color,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 48, color: AppColors.primary),
              const SizedBox(height: AppSpacing.lg),
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, height: 1.4)),
              if (hint != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 16, color: AppColors.onPrimaryContainer),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(hint!, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onPrimaryContainer, fontStyle: FontStyle.italic))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
