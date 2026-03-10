import '../enums/enums.dart';

/// Visit ticket — every visit starts with a ticket.
class VisitTicket {
  const VisitTicket({
    required this.id,
    required this.patientId,
    required this.visitType,
    required this.status,
    required this.queueNumber,
    required this.destinationClinicAreaId,
    required this.facilityId,
    this.qrPayload,
    this.encounterId,
    this.createdAt,
  });

  final String id;
  final String patientId;
  final VisitType visitType;
  final VisitStatus status;
  final int queueNumber;
  final String destinationClinicAreaId;
  final String facilityId;
  final String? qrPayload;
  final String? encounterId;
  final DateTime? createdAt;
}
