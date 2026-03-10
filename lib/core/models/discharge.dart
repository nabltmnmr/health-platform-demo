/// Discharge record for a visit.
class Discharge {
  const Discharge({
    required this.id,
    required this.ticketId,
    required this.encounterId,
    required this.patientId,
    required this.dischargedAt,
    this.summary,
    this.notes,
  });

  final String id;
  final String ticketId;
  final String encounterId;
  final String patientId;
  final DateTime dischargedAt;
  final String? summary;
  final String? notes;
}
