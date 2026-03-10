import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';

/// Step timeline for visit progress.
class StepTimeline extends StatelessWidget {
  const StepTimeline({
    super.key,
    required this.steps,
    this.currentIndex = 0,
  });

  final List<String> steps;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= currentIndex ? AppColors.primary : AppColors.surfaceVariant,
                      border: Border.all(color: i <= currentIndex ? AppColors.primary : AppColors.outline),
                    ),
                    child: i <= currentIndex
                        ? Icon(Icons.check, size: 14, color: AppColors.onPrimary)
                        : null,
                  ),
                  if (i < steps.length - 1)
                    Container(
                      width: 2,
                      height: 24,
                      color: i < currentIndex ? AppColors.primary : AppColors.outlineVariant,
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Text(
                    steps[i],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: i <= currentIndex ? AppColors.textPrimary : AppColors.textTertiary,
                      fontWeight: i == currentIndex ? FontWeight.w600 : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
