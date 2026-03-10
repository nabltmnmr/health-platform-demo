/// Lab request status.
enum LabRequestStatus {
  requested,
  sampleCollected,
  inProgress,
  completed,
  cancelled,
}

extension LabRequestStatusX on LabRequestStatus {
  String get label {
    switch (this) {
      case LabRequestStatus.requested:
        return 'Requested';
      case LabRequestStatus.sampleCollected:
        return 'Sample Collected';
      case LabRequestStatus.inProgress:
        return 'In Progress';
      case LabRequestStatus.completed:
        return 'Completed';
      case LabRequestStatus.cancelled:
        return 'Cancelled';
    }
  }
}
