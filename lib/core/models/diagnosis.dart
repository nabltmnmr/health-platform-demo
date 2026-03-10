/// Diagnosis recorded during encounter.
class Diagnosis {
  const Diagnosis({
    required this.id,
    required this.encounterId,
    required this.code,
    required this.description,
    this.notes,
    this.recordedAt,
  });

  final String id;
  final String encounterId;
  final String code;
  final String description;
  final String? notes;
  final DateTime? recordedAt;
}
