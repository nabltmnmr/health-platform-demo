import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';

/// Brand alternatives card for a national identifier.
class BrandAlternativesCard extends StatelessWidget {
  const BrandAlternativesCard({
    super.key,
    required this.nationalProductName,
    required this.brands,
    this.selectedBrandId,
    this.onSelectBrand,
  });

  final String nationalProductName;
  final List<BrandOption> brands;
  final String? selectedBrandId;
  final ValueChanged<String>? onSelectBrand;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(nationalProductName, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          ...brands.map((b) => RadioListTile<String>(
                title: Text(b.brandName),
                subtitle: b.companyName != null ? Text(b.companyName!, style: Theme.of(context).textTheme.bodySmall) : null,
                value: b.id,
                groupValue: selectedBrandId,
                onChanged: onSelectBrand != null ? (v) => v != null ? onSelectBrand!(v) : null : null,
                dense: true,
                contentPadding: EdgeInsets.zero,
              )),
        ],
      ),
    );
  }
}

class BrandOption {
  const BrandOption({required this.id, required this.brandName, this.companyName, this.quantity});
  final String id;
  final String brandName;
  final String? companyName;
  final int? quantity;
}
