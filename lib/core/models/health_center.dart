/// Health center under an institute.
class HealthCenter {
  const HealthCenter({
    required this.id,
    required this.name,
    required this.instituteId,
    this.departmentIds = const [],
  });

  final String id;
  final String name;
  final String instituteId;
  final List<String> departmentIds;
}
