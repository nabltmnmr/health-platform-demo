/// Clinic area (ER clinic, day clinic, night clinic).
class ClinicArea {
  const ClinicArea({
    required this.id,
    required this.name,
    required this.departmentId,
    required this.visitType,
  });

  final String id;
  final String name;
  final String departmentId;
  final String visitType; // maps to VisitType
}
