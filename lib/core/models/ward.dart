/// Ward for admitted patients.
class Ward {
  const Ward({
    required this.id,
    required this.name,
    required this.departmentId,
  });

  final String id;
  final String name;
  final String departmentId;
}
