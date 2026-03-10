/// Simulated transfer summary for UI.
class TransferSimulation {
  const TransferSimulation({
    required this.suggestionId,
    required this.quantity,
    this.status,
    this.estimatedWastePrevented,
  });

  final String suggestionId;
  final int quantity;
  final String? status;
  final int? estimatedWastePrevented;
}
