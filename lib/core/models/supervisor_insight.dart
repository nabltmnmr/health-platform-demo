/// Supervisor analytics insight (low stock, overstock, near expiry).
class SupervisorInsight {
  const SupervisorInsight({
    required this.id,
    required this.productNationalId,
    required this.insightType,
    this.instituteId,
    this.locationId,
    this.value,
    this.message,
    this.createdAt,
  });

  final String id;
  final String productNationalId;
  final String insightType; // lowStock, overstock, nearExpiry, missing
  final String? instituteId;
  final String? locationId;
  final num? value;
  final String? message;
  final DateTime? createdAt;
}
