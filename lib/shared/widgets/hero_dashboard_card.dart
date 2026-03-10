import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/shadows.dart';
import 'status_chip.dart';

/// Hero dashboard card for main actions or summaries.
class HeroDashboardCard extends StatelessWidget {
  const HeroDashboardCard({
    super.key,
    required this.title,
    this.subtitle,
    this.value,
    this.icon,
    this.statusChip,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? value;
  final IconData? icon;
  final String? statusChip;
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 32, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Text(title, style: Theme.of(context).textTheme.titleLarge),
                  ),
                  if (statusChip != null) StatusChip(label: statusChip!, size: StatusChipSize.small),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
              ],
              if (value != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(value!, style: Theme.of(context).textTheme.headlineSmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
