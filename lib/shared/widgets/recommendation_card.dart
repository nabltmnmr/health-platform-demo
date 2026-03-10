import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/shadows.dart';
import 'status_chip.dart';

/// Recommendation card for transfer suggestions.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.productName,
    required this.summary,
    this.sourceName,
    this.destinationName,
    this.quantity,
    this.reasonTags = const [],
    this.urgency,
    this.wastePrevented,
    this.wastePreventedLabel,
    this.quantityDisplay,
    this.onTap,
  });

  final String productName;
  final String summary;
  final String? sourceName;
  final String? destinationName;
  final int? quantity;
  final List<String> reasonTags;
  final String? urgency;
  final int? wastePrevented;
  /// When set, used instead of "Est. waste prevented: $wastePrevented units" for i18n.
  final String? wastePreventedLabel;
  /// When set, used instead of "Quantity: $quantity" for i18n.
  final String? quantityDisplay;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(productName, style: Theme.of(context).textTheme.titleMedium),
              ),
              if (urgency != null) StatusChip(label: urgency!, statusType: StatusChipType.warning, size: StatusChipSize.small),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(summary, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          if (sourceName != null && destinationName != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('$sourceName → $destinationName', style: Theme.of(context).textTheme.labelMedium),
          ],
          if (quantity != null || quantityDisplay != null) ...[
            const SizedBox(height: 2),
            Text(
              quantityDisplay ?? 'Quantity: $quantity',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (reasonTags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: reasonTags.map((t) => StatusChip(label: t, statusType: StatusChipType.neutral, size: StatusChipSize.small)).toList(),
            ),
          ],
          if (wastePreventedLabel != null || (wastePrevented != null && wastePreventedLabel == null)) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              wastePreventedLabel ?? 'Est. waste prevented: $wastePrevented units',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.success),
            ),
          ],
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(AppRadii.lg), child: child);
    }
    return child;
  }
}
