/// Current status of a visit/ticket.
enum VisitStatus {
  queued,
  inProgress,
  awaitingPharmacy,
  awaitingLab,
  awaitingNursing,
  readyForDischarge,
  discharged,
  admittedToWard,
}

extension VisitStatusX on VisitStatus {
  String get label {
    switch (this) {
      case VisitStatus.queued:
        return 'Queued';
      case VisitStatus.inProgress:
        return 'In Progress';
      case VisitStatus.awaitingPharmacy:
        return 'Awaiting Pharmacy';
      case VisitStatus.awaitingLab:
        return 'Awaiting Lab';
      case VisitStatus.awaitingNursing:
        return 'Awaiting Nursing';
      case VisitStatus.readyForDischarge:
        return 'Ready for Discharge';
      case VisitStatus.discharged:
        return 'Discharged';
      case VisitStatus.admittedToWard:
        return 'Admitted to Ward';
    }
  }
}
