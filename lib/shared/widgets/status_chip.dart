import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/radii.dart';

/// Status chip for visit, prescription, stock, etc.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.statusType = StatusChipType.neutral,
    this.size = StatusChipSize.medium,
  });

  final String label;
  final StatusChipType statusType;
  final StatusChipSize size;

  @override
  Widget build(BuildContext context) {
    final (color, bg) = _colors;
    final padding = size == StatusChipSize.small
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.full),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  (Color, Color) get _colors {
    switch (statusType) {
      case StatusChipType.success:
        return (AppColors.success, AppColors.successContainer);
      case StatusChipType.warning:
        return (AppColors.warning, AppColors.warningContainer);
      case StatusChipType.danger:
        return (AppColors.danger, AppColors.dangerContainer);
      case StatusChipType.primary:
        return (AppColors.primary, AppColors.primaryContainer);
      case StatusChipType.neutral:
        return (AppColors.textSecondary, AppColors.surfaceVariant);
    }
  }
}

enum StatusChipType { neutral, primary, success, warning, danger }

enum StatusChipSize { small, medium }
