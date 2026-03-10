import '../enums/enums.dart';

/// Stock batch — belongs to a brand and a location.
class StockBatch {
  const StockBatch({
    required this.id,
    required this.productBrandId,
    required this.locationId,
    required this.batchNumber,
    required this.expiryDate,
    required this.quantity,
    this.receivedAt,
  });

  final String id;
  final String productBrandId;
  final String locationId;
  final String batchNumber;
  final DateTime expiryDate;
  final int quantity;
  final DateTime? receivedAt;

  ExpiryRiskLevel get expiryRisk {
    final now = DateTime.now();
    if (expiryDate.isBefore(now)) return ExpiryRiskLevel.expired;
    final monthsLeft = (expiryDate.year - now.year) * 12 + (expiryDate.month - now.month);
    if (monthsLeft <= 1) return ExpiryRiskLevel.high;
    if (monthsLeft <= 3) return ExpiryRiskLevel.medium;
    if (monthsLeft <= 6) return ExpiryRiskLevel.low;
    return ExpiryRiskLevel.none;
  }
}
