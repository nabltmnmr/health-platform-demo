import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/radii.dart';

/// Demand signal chip for unavailable / requested items.
class DemandSignalChip extends StatelessWidget {
  const DemandSignalChip({
    super.key,
    required this.label,
    this.count,
    this.onTap,
  });

  final String label;
  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dangerContainer.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(AppRadii.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.signal_cellular_alt, size: 14, color: AppColors.danger),
              const SizedBox(width: 4),
              Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onDangerContainer)),
              if (count != null) ...[
                const SizedBox(width: 4),
                Text('$count', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onDangerContainer, fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
