import '../enums/enums.dart';

/// Request from pharmacy/area to inventory for supply.
class SupplyRequest {
  const SupplyRequest({
    required this.id,
    required this.requestingLocationId,
    required this.productNationalId,
    required this.quantity,
    this.status = SupplyRequestStatus.pending,
    this.fulfillmentIds = const [],
    this.requestedAt,
    this.notes,
  });

  final String id;
  final String requestingLocationId;
  final String productNationalId;
  final int quantity;
  final SupplyRequestStatus status;
  final List<String> fulfillmentIds;
  final DateTime? requestedAt;
  final String? notes;
}
