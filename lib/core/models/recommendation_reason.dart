/// Reason tag for recommendations.
class RecommendationReason {
  const RecommendationReason({
    required this.id,
    required this.label,
    this.type,
  });

  final String id;
  final String label;
  final String? type; // shortage, overstock, expiry, etc.
}
