/// Stock movement transaction.
class StockTransaction {
  const StockTransaction({
    required this.id,
    required this.batchId,
    required this.quantity,
    required this.type,
    this.referenceId,
    this.occurredAt,
    this.notes,
  });

  final String id;
  final String batchId;
  final int quantity; // negative for dispense/issue
  final String type; // receive, issue, dispense, transfer, adjust
  final String? referenceId;
  final DateTime? occurredAt;
  final String? notes;
}
