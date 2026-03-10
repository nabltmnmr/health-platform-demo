import '../enums/enums.dart';

/// Expiry risk summary for a product/location.
class ExpiryRiskSummary {
  const ExpiryRiskSummary({
    required this.productNationalId,
    required this.locationId,
    this.quantityAtRisk,
    this.earliestExpiry,
    this.riskLevel = ExpiryRiskLevel.none,
  });

  final String productNationalId;
  final String locationId;
  final int? quantityAtRisk;
  final DateTime? earliestExpiry;
  final ExpiryRiskLevel riskLevel;
}
