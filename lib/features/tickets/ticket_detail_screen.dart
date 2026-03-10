import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/patient_header_card.dart';
import '../../../shared/widgets/ticket_qr_card.dart';
import '../../../shared/widgets/status_chip.dart';

class TicketDetailScreen extends ConsumerWidget {
  const TicketDetailScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticket = ref.watch(ticketRepositoryProvider).getById(ticketId);
    if (ticket == null) {
      return const Center(child: Text('Ticket not found'));
    }
    final patient = ref.watch(patientRepositoryProvider).getById(ticket.patientId);
    final destArea = SeedData.clinicAreas.where((c) => c.id == ticket.destinationClinicAreaId).toList();
    final destName = destArea.isNotEmpty ? destArea.first.name : ticket.destinationClinicAreaId;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTicketInfo(context, ticket, destName),
                          const SizedBox(height: AppSpacing.lg),
                          if (patient != null)
                            PatientHeaderCard(
                              patientName: patient.name,
                              age: patient.ageYears,
                              sex: patient.sex,
                              allergies: patient.allergies,
                              medicalRecordNumber: patient.medicalRecordNumber,
                              visitType: ticket.visitType.label,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    SizedBox(
                      width: 220,
                      child: TicketQRCard(
                        payload: ticket.qrPayload ?? 'TICKET:${ticket.id}',
                        size: 200,
                        ticketId: ticket.id,
                        queueNumber: ticket.queueNumber,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TicketQRCard(
                      payload: ticket.qrPayload ?? 'TICKET:${ticket.id}',
                      ticketId: ticket.id,
                      queueNumber: ticket.queueNumber,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildTicketInfo(context, ticket, destName),
                    if (patient != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      PatientHeaderCard(
                        patientName: patient.name,
                        age: patient.ageYears,
                        sex: patient.sex,
                        allergies: patient.allergies,
                        medicalRecordNumber: patient.medicalRecordNumber,
                        visitType: ticket.visitType.label,
                      ),
                    ],
                  ],
                );
        },
      ),
    );
  }

  Widget _buildTicketInfo(BuildContext context, VisitTicket ticket, String destName) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(ticket.id, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: AppSpacing.md),
              StatusChip(label: ticket.status.label, statusType: _statusType(ticket.status)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _infoRow(context, 'Queue number', '#${ticket.queueNumber}'),
          _infoRow(context, 'Visit type', ticket.visitType.label),
          _infoRow(context, 'Destination', destName),
          const SizedBox(height: AppSpacing.lg),
          if (ticket.encounterId != null)
            FilledButton.icon(
              onPressed: () => context.push('/encounter/${ticket.id}'),
              icon: const Icon(Icons.medical_information),
              label: const Text('Open Encounter'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            )
          else
            FilledButton.icon(
              onPressed: () => context.push('/encounter/${ticket.id}/start'),
              icon: const Icon(Icons.add),
              label: const Text('Start Encounter'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            ),
        ],
      ),
    );
  }

  StatusChipType _statusType(VisitStatus s) {
    switch (s) {
      case VisitStatus.discharged:
        return StatusChipType.success;
      case VisitStatus.inProgress:
        return StatusChipType.primary;
      default:
        return StatusChipType.neutral;
    }
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
