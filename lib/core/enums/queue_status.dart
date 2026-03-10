/// Queue entry status.
enum QueueStatus {
  waiting,
  called,
  inProgress,
  completed,
  skipped,
}

extension QueueStatusX on QueueStatus {
  String get label {
    switch (this) {
      case QueueStatus.waiting:
        return 'Waiting';
      case QueueStatus.called:
        return 'Called';
      case QueueStatus.inProgress:
        return 'In Progress';
      case QueueStatus.completed:
        return 'Completed';
      case QueueStatus.skipped:
        return 'Skipped';
    }
  }
}
