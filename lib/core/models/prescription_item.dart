/// Single line item in a prescription (by national identifier).
class PrescriptionItem {
  const PrescriptionItem({
    required this.id,
    required this.prescriptionId,
    required this.productNationalId,
    required this.quantity,
    this.instructions,
    this.dispensedQuantity = 0,
    this.batchId,
  });

  final String id;
  final String prescriptionId;
  final String productNationalId;
  final int quantity;
  final String? instructions;
  final int dispensedQuantity;
  final String? batchId;
}
