/// Ward admission record.
class Admission {
  const Admission({
    required this.id,
    required this.ticketId,
    required this.patientId,
    required this.wardId,
    required this.admittedAt,
    this.dischargeId,
    this.notes,
  });

  final String id;
  final String ticketId;
  final String patientId;
  final String wardId;
  final DateTime admittedAt;
  final String? dischargeId;
  final String? notes;
}
