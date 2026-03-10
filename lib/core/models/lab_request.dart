import '../enums/enums.dart';

/// Lab test request.
class LabRequest {
  const LabRequest({
    required this.id,
    required this.encounterId,
    required this.patientId,
    required this.testName,
    this.status = LabRequestStatus.requested,
    this.sampleCollectedAt,
    this.completedAt,
    this.resultId,
    this.notes,
  });

  final String id;
  final String encounterId;
  final String patientId;
  final String testName;
  final LabRequestStatus status;
  final DateTime? sampleCollectedAt;
  final DateTime? completedAt;
  final String? resultId;
  final String? notes;
}
