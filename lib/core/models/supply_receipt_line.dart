/// Single line in a supply receipt (one batch received).
class SupplyReceiptLine {
  const SupplyReceiptLine({
    required this.productBrandId,
    required this.batchNumber,
    required this.quantity,
    required this.expiryDate,
  });

  final String productBrandId;
  final String batchNumber;
  final int quantity;
  final DateTime expiryDate;
}
