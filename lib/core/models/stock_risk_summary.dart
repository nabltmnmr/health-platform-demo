/// Stock risk summary by product/location.
class StockRiskSummary {
  const StockRiskSummary({
    required this.productNationalId,
    required this.locationId,
    this.totalQuantity,
    this.lowStock = false,
    this.overstock = false,
    this.daysUntilStockOut,
  });

  final String productNationalId;
  final String locationId;
  final int? totalQuantity;
  final bool lowStock;
  final bool overstock;
  final int? daysUntilStockOut;
}
