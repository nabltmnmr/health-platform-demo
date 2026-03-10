/// Hospital under an institute; contains departments and areas.
class Hospital {
  const Hospital({
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
