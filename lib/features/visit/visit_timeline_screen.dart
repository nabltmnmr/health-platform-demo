import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/enums/enums.dart';
import '../../../core/models/models.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/repositories/encounter_repository.dart';
import '../../../core/repositories/pharmacy_repository.dart';
import '../../../core/repositories/lab_repository.dart';
import '../../../core/repositories/nursing_repository.dart';
import '../../../shared/widgets/patient_header_card.dart';
import '../../../shared/widgets/step_timeline.dart';

class VisitTimelineScreen extends ConsumerWidget {
  const VisitTimelineScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticket = ref.watch(ticketRepositoryProvider).getById(ticketId);
    if (ticket == null) return const Center(child: Text('Ticket not found'));

    final patient = ref.watch(patientRepositoryProvider).getById(ticket.patientId);
    final encounter = ref.watch(encounterRepositoryProvider).getByTicketId(ticketId);
    final diagnoses = encounter != null ? ref.watch(encounterRepositoryProvider).getDiagnosesByEncounter(encounter.id) : <Diagnosis>[];
    final prescription = encounter?.prescriptionId != null ? ref.watch(pharmacyRepositoryProvider).getPrescriptionById(encounter!.prescriptionId!) : null;
    final labRequests = encounter != null ? ref.watch(labRepositoryProvider).allRequests.where((r) => encounter.labRequestIds.contains(r.id)).toList() : <LabRequest>[];
    final treatments = encounter != null ? ref.watch(nursingRepositoryProvider).allOrders.where((o) => encounter.treatmentOrderIds.contains(o.id)).toList() : <TreatmentOrder>[];

    final steps = ['Ticket', 'Encounter', 'Diagnosis', 'Prescription', 'Lab', 'Nursing', 'Discharge'];
    var current = 0;
    if (ticket.status == VisitStatus.discharged || ticket.status == VisitStatus.admittedToWard) current = 6;
    else if (treatments.isNotEmpty) current = 5;
    else if (labRequests.isNotEmpty) current = 4;
    else if (prescription != null) current = 3;
    else if (diagnoses.isNotEmpty) current = 2;
    else if (encounter != null) current = 1;

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
              visitType: ticket.status.label,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          Text('Visit Summary', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          StepTimeline(steps: steps, currentIndex: current),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: ${ticket.status.label}', style: Theme.of(context).textTheme.titleMedium),
                  if (diagnoses.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Diagnoses', style: Theme.of(context).textTheme.labelLarge),
                    ...diagnoses.map((d) => ListTile(dense: true, title: Text(d.description), subtitle: Text(d.code))),
                  ],
                  if (prescription != null) ...[
                    const SizedBox(height: 12),
                    Text('Prescription: ${prescription.items.length} item(s)', style: Theme.of(context).textTheme.labelLarge),
                  ],
                  if (labRequests.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Lab: ${labRequests.length} test(s)', style: Theme.of(context).textTheme.labelLarge),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
