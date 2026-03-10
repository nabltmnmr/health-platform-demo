import '../enums/enums.dart';

/// AI transfer recommendation between institutes/locations.
class TransferSuggestion {
  const TransferSuggestion({
    required this.id,
    required this.productNationalId,
    required this.sourceLocationId,
    required this.destinationLocationId,
    required this.sourceInstituteId,
    required this.destinationInstituteId,
    required this.quantity,
    required this.reasons,
    this.priority = RecommendationPriority.medium,
    this.estimatedWastePrevented,
    this.shortageRelief = false,
    this.expiryPrevention = false,
    this.createdAt,
  });

  final String id;
  final String productNationalId;
  final String sourceLocationId;
  final String destinationLocationId;
  final String sourceInstituteId;
  final String destinationInstituteId;
  final int quantity;
  final List<String> reasons;
  final RecommendationPriority priority;
  final int? estimatedWastePrevented;
  final bool shortageRelief;
  final bool expiryPrevention;
  final DateTime? createdAt;
}
