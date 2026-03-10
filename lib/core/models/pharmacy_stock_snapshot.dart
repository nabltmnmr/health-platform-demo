/// Snapshot of pharmacy stock for display.
class PharmacyStockSnapshot {
  const PharmacyStockSnapshot({
    required this.pharmacyAreaId,
    required this.productNationalId,
    required this.totalQuantity,
    this.batchCount,
    this.lowStockThreshold,
    this.nearExpiryCount,
  });

  final String pharmacyAreaId;
  final String productNationalId;
  final int totalQuantity;
  final int? batchCount;
  final int? lowStockThreshold;
  final int? nearExpiryCount;
}
