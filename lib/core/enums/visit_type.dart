/// Type of visit / ticket destination.
enum VisitType {
  er,
  dayClinic,
  nightClinic,
  wardResident,
}

extension VisitTypeX on VisitType {
  String get label {
    switch (this) {
      case VisitType.er:
        return 'ER';
      case VisitType.dayClinic:
        return 'Day Clinic';
      case VisitType.nightClinic:
        return 'Night Clinic';
      case VisitType.wardResident:
        return 'Ward Resident';
    }
  }
}
