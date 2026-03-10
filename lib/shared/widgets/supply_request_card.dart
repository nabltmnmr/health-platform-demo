import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';
import 'status_chip.dart';

/// Supply request card for inventory queue.
class SupplyRequestCard extends StatelessWidget {
  const SupplyRequestCard({
    super.key,
    required this.productName,
    required this.requestedQuantity,
    this.requestingAreaName,
    this.statusLabel,
    this.onTap,
  });

  final String productName;
  final int requestedQuantity;
  final String? requestingAreaName;
  final String? statusLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(productName, style: Theme.of(context).textTheme.titleSmall),
              ),
              if (statusLabel != null) StatusChip(label: statusLabel!, size: StatusChipSize.small),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Qty: $requestedQuantity', style: Theme.of(context).textTheme.bodyMedium),
          if (requestingAreaName != null)
            Text(requestingAreaName!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(AppRadii.lg), child: child);
    }
    return child;
  }
}
