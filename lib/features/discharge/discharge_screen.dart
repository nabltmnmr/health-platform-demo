import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/repositories/encounter_repository.dart';
import '../../../shared/widgets/patient_header_card.dart';

class DischargeScreen extends ConsumerStatefulWidget {
  const DischargeScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  ConsumerState<DischargeScreen> createState() => _DischargeScreenState();
}

class _DischargeScreenState extends ConsumerState<DischargeScreen> {
  bool _admitToWard = false;

  @override
  Widget build(BuildContext context) {
    final ticket = ref.watch(ticketRepositoryProvider).getById(widget.ticketId);
    if (ticket == null) return const Center(child: Text('Ticket not found'));

    final patient = ref.watch(patientRepositoryProvider).getById(ticket.patientId);
    final encounter = ref.watch(encounterRepositoryProvider).getByTicketId(widget.ticketId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (patient != null) ...[
            PatientHeaderCard(
              patientName: patient.name,
              age: patient.ageYears,
              sex: patient.sex,
              allergies: patient.allergies,
              medicalRecordNumber: patient.medicalRecordNumber,
              visitType: ticket.visitType.label,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          Text('Discharge or Admit', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Admit to ward'),
                  value: _admitToWard,
                  onChanged: (v) => setState(() => _admitToWard = v),
                ),
                const Divider(),
                ListTile(
                  title: Text(_admitToWard ? 'Admit to Ward' : 'Discharge'),
                  subtitle: Text(_admitToWard ? 'Transfer patient to ward' : 'Complete visit and discharge'),
                  trailing: FilledButton(
                    onPressed: () => _complete(ticket, encounter),
                    child: Text(_admitToWard ? 'Admit' : 'Discharge'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _complete(VisitTicket ticket, Encounter? encounter) {
    final status = _admitToWard ? VisitStatus.admittedToWard : VisitStatus.discharged;
    ref.read(ticketRepositoryProvider).update(VisitTicket(
      id: ticket.id, patientId: ticket.patientId, visitType: ticket.visitType, status: status,
      queueNumber: ticket.queueNumber, destinationClinicAreaId: ticket.destinationClinicAreaId, facilityId: ticket.facilityId,
      qrPayload: ticket.qrPayload, encounterId: ticket.encounterId, createdAt: ticket.createdAt,
    ));
    if (encounter != null) {
      ref.read(encounterRepositoryProvider).updateEncounter(Encounter(
        id: encounter.id, ticketId: encounter.ticketId, patientId: encounter.patientId, providerId: encounter.providerId,
        diagnosisIds: encounter.diagnosisIds, prescriptionId: encounter.prescriptionId, labRequestIds: encounter.labRequestIds,
        treatmentOrderIds: encounter.treatmentOrderIds, status: status, startedAt: encounter.startedAt,
        endedAt: DateTime.now(), notes: encounter.notes,
      ));
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_admitToWard ? 'Admitted to ward' : 'Discharged')));
      context.pop();
      context.push('/visit-timeline/${ticket.id}');
    }
  }
}
