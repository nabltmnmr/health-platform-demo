import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/services/locale_provider.dart';
import '../../../core/l10n/app_localizations.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(demoUsersProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.medical_services, size: 56, color: AppColors.primary),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary)),
                const SizedBox(height: AppSpacing.xxs),
                Text(l10n.loginSubtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.loginTip, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary, fontStyle: FontStyle.italic)),
                const SizedBox(height: AppSpacing.xxl),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => toggleLocale(ref),
                    icon: const Icon(Icons.language, size: 20),
                    label: Text(l10n.isAr ? 'English' : 'العربية'),
                  ),
                ),
                ...users.map((user) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    tileColor: AppColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    leading: CircleAvatar(backgroundColor: AppColors.primaryContainer, child: Text(user.name.substring(0, 1).toUpperCase(), style: const TextStyle(color: AppColors.onPrimaryContainer))),
                    title: Text(user.displayName),
                    subtitle: Text(l10n.roleLabel(user.role)),
                    onTap: () {
                      ref.read(currentUserProvider.notifier).state = user;
                      context.go('/institute-selector');
                    },
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
