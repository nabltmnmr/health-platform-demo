/// Prescription or prescription item status.
enum PrescriptionStatus {
  pending,
  partiallyDispensed,
  dispensed,
  cancelled,
}

extension PrescriptionStatusX on PrescriptionStatus {
  String get label {
    switch (this) {
      case PrescriptionStatus.pending:
        return 'Pending';
      case PrescriptionStatus.partiallyDispensed:
        return 'Partially Dispensed';
      case PrescriptionStatus.dispensed:
        return 'Dispensed';
      case PrescriptionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
