/// Nursing treatment order status.
enum TreatmentStatus {
  pending,
  due,
  administered,
  delayed,
  cancelled,
}

extension TreatmentStatusX on TreatmentStatus {
  String get label {
    switch (this) {
      case TreatmentStatus.pending:
        return 'Pending';
      case TreatmentStatus.due:
        return 'Due';
      case TreatmentStatus.administered:
        return 'Administered';
      case TreatmentStatus.delayed:
        return 'Delayed';
      case TreatmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}
