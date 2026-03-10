import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';
import 'status_chip.dart';

/// Medication availability row (national ID + availability chip).
class MedicationAvailabilityRow extends StatelessWidget {
  const MedicationAvailabilityRow({
    super.key,
    required this.productName,
    required this.stockStatus,
    this.alternativesCount,
    this.onTap,
  });

  final String productName;
  final StockAvailabilityStatus stockStatus;
  final int? alternativesCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (label, type) = _statusLabel;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Text(productName, style: Theme.of(context).textTheme.bodyMedium),
              ),
              StatusChip(label: label, statusType: type, size: StatusChipSize.small),
              if (alternativesCount != null && alternativesCount! > 0) ...[
                const SizedBox(width: AppSpacing.sm),
                Text('${alternativesCount!} brands', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  (String, StatusChipType) get _statusLabel {
    switch (stockStatus) {
      case StockAvailabilityStatus.available:
        return ('Available', StatusChipType.success);
      case StockAvailabilityStatus.lowStock:
        return ('Low stock', StatusChipType.warning);
      case StockAvailabilityStatus.unavailable:
        return ('Unavailable', StatusChipType.danger);
    }
  }
}

enum StockAvailabilityStatus { available, lowStock, unavailable }
