/// Priority for AI transfer recommendations.
enum RecommendationPriority {
  low,
  medium,
  high,
  urgent,
}

extension RecommendationPriorityX on RecommendationPriority {
  String get label {
    switch (this) {
      case RecommendationPriority.low:
        return 'Low';
      case RecommendationPriority.medium:
        return 'Medium';
      case RecommendationPriority.high:
        return 'High';
      case RecommendationPriority.urgent:
        return 'Urgent';
    }
  }
}
