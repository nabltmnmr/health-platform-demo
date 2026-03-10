/// Supply request status.
enum SupplyRequestStatus {
  pending,
  approved,
  fulfilled,
  partial,
  cancelled,
}

extension SupplyRequestStatusX on SupplyRequestStatus {
  String get label {
    switch (this) {
      case SupplyRequestStatus.pending:
        return 'Pending';
      case SupplyRequestStatus.approved:
        return 'Approved';
      case SupplyRequestStatus.fulfilled:
        return 'Fulfilled';
      case SupplyRequestStatus.partial:
        return 'Partially Fulfilled';
      case SupplyRequestStatus.cancelled:
        return 'Cancelled';
    }
  }
}
