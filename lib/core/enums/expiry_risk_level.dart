/// Expiry risk level for batches.
enum ExpiryRiskLevel {
  none,
  low,
  medium,
  high,
  expired,
}

extension ExpiryRiskLevelX on ExpiryRiskLevel {
  String get label {
    switch (this) {
      case ExpiryRiskLevel.none:
        return 'None';
      case ExpiryRiskLevel.low:
        return 'Low';
      case ExpiryRiskLevel.medium:
        return 'Medium';
      case ExpiryRiskLevel.high:
        return 'High';
      case ExpiryRiskLevel.expired:
        return 'Expired';
    }
  }
}
