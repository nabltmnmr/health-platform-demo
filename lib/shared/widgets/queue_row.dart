import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';
import 'status_chip.dart';

/// Queue row for clinic/pharmacy/lab/nursing queue.
class QueueRow extends StatelessWidget {
  const QueueRow({
    super.key,
    required this.queueNumber,
    required this.patientName,
    this.statusLabel,
    this.onTap,
  });

  final int queueNumber;
  final String patientName;
  final String? statusLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Text('$queueNumber', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onPrimaryContainer)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(patientName, style: Theme.of(context).textTheme.bodyLarge),
              ),
              if (statusLabel != null) StatusChip(label: statusLabel!, size: StatusChipSize.small),
            ],
          ),
        ),
      ),
    );
  }
}
