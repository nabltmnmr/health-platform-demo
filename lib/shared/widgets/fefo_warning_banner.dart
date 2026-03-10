import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';

/// FEFO warning banner.
class FefoWarningBanner extends StatelessWidget {
  const FefoWarningBanner({
    super.key,
    required this.message,
    this.recommendedBatch,
  });

  final String message;
  final String? recommendedBatch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warningContainer,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('FEFO — First Expire, First Out', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onWarningContainer)),
                const SizedBox(height: 2),
                Text(message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onWarningContainer)),
                if (recommendedBatch != null) ...[
                  const SizedBox(height: 4),
                  Text('Use batch: $recommendedBatch', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onWarningContainer)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
