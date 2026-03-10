import '../enums/enums.dart';

/// Clinical encounter linked to a visit.
class Encounter {
  const Encounter({
    required this.id,
    required this.ticketId,
    required this.patientId,
    required this.providerId,
    this.diagnosisIds = const [],
    this.prescriptionId,
    this.labRequestIds = const [],
    this.treatmentOrderIds = const [],
    this.status = VisitStatus.inProgress,
    this.startedAt,
    this.endedAt,
    this.notes,
  });

  final String id;
  final String ticketId;
  final String patientId;
  final String providerId;
  final List<String> diagnosisIds;
  final String? prescriptionId;
  final List<String> labRequestIds;
  final List<String> treatmentOrderIds;
  final VisitStatus status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? notes;
}
