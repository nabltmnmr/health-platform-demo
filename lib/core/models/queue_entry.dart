import '../enums/enums.dart';

/// Entry in a queue (clinic, pharmacy, lab, nursing).
class QueueEntry {
  const QueueEntry({
    required this.id,
    required this.ticketId,
    required this.patientId,
    required this.areaId,
    required this.areaType,
    required this.queueNumber,
    required this.status,
    this.calledAt,
    this.completedAt,
  });

  final String id;
  final String ticketId;
  final String patientId;
  final String areaId;
  final String areaType; // clinic, pharmacy, lab, nursing
  final int queueNumber;
  final QueueStatus status;
  final DateTime? calledAt;
  final DateTime? completedAt;
}
