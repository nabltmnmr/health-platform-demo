/// Fulfillment of a supply request (issue from batch).
class SupplyFulfillment {
  const SupplyFulfillment({
    required this.id,
    required this.supplyRequestId,
    required this.batchId,
    required this.quantity,
    this.fulfilledAt,
    this.fulfilledById,
  });

  final String id;
  final String supplyRequestId;
  final String batchId;
  final int quantity;
  final DateTime? fulfilledAt;
  final String? fulfilledById;
}
