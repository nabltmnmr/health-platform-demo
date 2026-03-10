import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';

/// Patient header card — name, age, sex, allergies.
class PatientHeaderCard extends StatelessWidget {
  const PatientHeaderCard({
    super.key,
    required this.patientName,
    this.age,
    this.sex,
    this.allergies = const [],
    this.medicalRecordNumber,
    this.visitType,
  });

  final String patientName;
  final int? age;
  final String? sex;
  final List<String> allergies;
  final String? medicalRecordNumber;
  final String? visitType;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              CircleAvatar(backgroundColor: AppColors.primaryContainer, child: Text(patientName.isNotEmpty ? patientName.substring(0, 1).toUpperCase() : '?', style: const TextStyle(color: AppColors.onPrimaryContainer))),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patientName, style: Theme.of(context).textTheme.titleLarge),
                    if (age != null || sex != null)
                      Text(
                        [if (age != null) '$age yrs', if (sex != null) sex].join(' · '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
              if (visitType != null) Text(visitType!, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
            ],
          ),
          if (medicalRecordNumber != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('MRN: $medicalRecordNumber', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
          ],
          if (allergies.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: AppSpacing.xs),
                Text('Allergies: ${allergies.join(", ")}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.warning)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
