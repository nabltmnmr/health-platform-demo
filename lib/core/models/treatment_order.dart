import '../enums/enums.dart';

/// Nursing treatment order.
class TreatmentOrder {
  const TreatmentOrder({
    required this.id,
    required this.encounterId,
    required this.patientId,
    required this.description,
    required this.dueAt,
    this.status = TreatmentStatus.pending,
    this.administrationRecordIds = const [],
    this.notes,
    this.medicationDispensed,
  });

  final String id;
  final String encounterId;
  final String patientId;
  final String description;
  final DateTime dueAt;
  final TreatmentStatus status;
  final List<String> administrationRecordIds;
  final String? notes;
  /// True when the medication for this treatment has been dispensed by pharmacy. Null-safe for older data.
  final bool? medicationDispensed;
}
