/// Record of treatment administration.
class AdministrationRecord {
  const AdministrationRecord({
    required this.id,
    required this.treatmentOrderId,
    required this.administeredAt,
    this.administeredById,
    this.notes,
  });

  final String id;
  final String treatmentOrderId;
  final DateTime administeredAt;
  final String? administeredById;
  final String? notes;
}
