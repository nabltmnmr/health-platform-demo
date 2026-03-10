/// Consumption statistic for analytics.
class ConsumptionStat {
  const ConsumptionStat({
    required this.productNationalId,
    required this.locationId,
    required this.periodStart,
    required this.periodEnd,
    required this.quantityConsumed,
  });

  final String productNationalId;
  final String locationId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int quantityConsumed;
}
