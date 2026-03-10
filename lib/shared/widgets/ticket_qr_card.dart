import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/radii.dart';

/// Ticket QR code card.
class TicketQRCard extends StatelessWidget {
  const TicketQRCard({
    super.key,
    required this.payload,
    this.size = 140,
    this.ticketId,
    this.queueNumber,
  });

  final String payload;
  final double size;
  final String? ticketId;
  final int? queueNumber;

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
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: payload,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
          ),
          if (ticketId != null || queueNumber != null) ...[
            const SizedBox(height: AppSpacing.sm),
            if (ticketId != null) Text(ticketId!, style: Theme.of(context).textTheme.labelLarge),
            if (queueNumber != null) Text('Queue #$queueNumber', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }
}
