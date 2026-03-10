import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';

/// Filter chips row.
class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.labels,
    this.selectedIndex = 0,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < labels.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: FilterChip(
                label: Text(labels[i]),
                selected: i == selectedIndex,
                onSelected: (_) => onSelected(i),
                backgroundColor: AppColors.surfaceVariant,
                selectedColor: AppColors.primaryContainer,
                checkmarkColor: AppColors.onPrimaryContainer,
              ),
            ),
        ],
      ),
    );
  }
}
