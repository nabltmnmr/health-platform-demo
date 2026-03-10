import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';
import '../../core/enums/enums.dart';

/// Role switch tile for login/demo.
class RoleSwitchTile extends StatelessWidget {
  const RoleSwitchTile({
    super.key,
    required this.role,
    required this.userName,
    this.selected = false,
    required this.onTap,
  });

  final UserRole role;
  final String userName;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryContainer.withValues(alpha: 0.5) : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryContainer,
                child: Text(userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : '?', style: const TextStyle(color: AppColors.onPrimaryContainer)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(userName, style: Theme.of(context).textTheme.titleSmall),
                    Text(role.label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_circle, color: AppColors.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
