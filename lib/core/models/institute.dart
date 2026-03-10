/// Top-level institute supervising hospitals and health centers.
class Institute {
  const Institute({
    required this.id,
    required this.name,
    this.hospitalIds = const [],
    this.healthCenterIds = const [],
  });

  final String id;
  final String name;
  final List<String> hospitalIds;
  final List<String> healthCenterIds;
}
