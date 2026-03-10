import 'supply_receipt_line.dart';
import '../enums/enums.dart';

/// Record of supply received from outside (transfer, health dept, or 3rd party).
class SupplyReceipt {
  const SupplyReceipt({
    required this.id,
    required this.receivedAt,
    required this.sourceType,
    required this.supplierName,
    required this.lineItems,
    this.referenceNumber,
    this.notes,
    this.destinationLocationId = 'loc-drug-depot',
  });

  final String id;
  final DateTime receivedAt;
  final SupplySourceType sourceType;
  final String supplierName;
  final List<SupplyReceiptLine> lineItems;
  final String? referenceNumber;
  final String? notes;
  final String destinationLocationId;
}
