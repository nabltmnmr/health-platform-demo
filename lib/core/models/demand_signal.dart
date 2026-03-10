/// Demand signal when item unavailable during prescription/dispensing.
class DemandSignal {
  const DemandSignal({
    required this.id,
    required this.productNationalId,
    required this.locationId,
    this.requestCount = 1,
    this.lastRequestedAt,
    this.notes,
  });

  final String id;
  final String productNationalId;
  final String locationId;
  final int requestCount;
  final DateTime? lastRequestedAt;
  final String? notes;
}
