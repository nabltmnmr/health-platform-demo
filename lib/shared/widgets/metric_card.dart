import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/shadows.dart';

/// Metric / stat card for dashboards.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    this.value,
    this.subtitle,
    this.icon,
    this.trend,
    this.onTap,
  });

  final String title;
  final String? value;
  final String? subtitle;
  final IconData? icon;
  final String? trend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 24, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          if (value != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(value!, style: Theme.of(context).textTheme.headlineMedium),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
          ],
          if (trend != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(trend!, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.success)),
          ],
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: child,
      );
    }
    return child;
  }
}
