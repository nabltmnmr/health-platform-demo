import '../../../core/repositories/encounter_repository.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/seed/seed_data.dart';

/// Location category for queue grouping: ER, Clinics, or Wards.
enum QueueLocationCategory {
  er,
  clinics,
  wards,
}

extension QueueLocationCategoryX on QueueLocationCategory {
  String get label {
    switch (this) {
      case QueueLocationCategory.er:
        return 'ER';
      case QueueLocationCategory.clinics:
        return 'Clinics';
      case QueueLocationCategory.wards:
        return 'Wards';
    }
  }
}

/// Resolves encounter to ER / Clinics / Wards from ticket destination clinic area.
QueueLocationCategory getQueueLocationCategory(
  String encounterId,
  EncounterRepository encounterRepo,
  TicketRepository ticketRepo,
) {
  final encounter = encounterRepo.getById(encounterId);
  if (encounter == null) return QueueLocationCategory.clinics;
  final ticket = ticketRepo.getById(encounter.ticketId);
  if (ticket == null) return QueueLocationCategory.clinics;
  final areaList = SeedData.clinicAreas.where((a) => a.id == ticket.destinationClinicAreaId).toList();
  final area = areaList.isEmpty ? null : areaList.first;
  if (area == null) return QueueLocationCategory.clinics;
  switch (area.visitType) {
    case 'er':
      return QueueLocationCategory.er;
    case 'wardResident':
      return QueueLocationCategory.wards;
    case 'dayClinic':
    case 'nightClinic':
    default:
      return QueueLocationCategory.clinics;
  }
}

/// Department id for the encounter's ticket destination (clinic area's department). Null if unknown.
String? getDepartmentIdForEncounter(
  String encounterId,
  EncounterRepository encounterRepo,
  TicketRepository ticketRepo,
) {
  final encounter = encounterRepo.getById(encounterId);
  if (encounter == null) return null;
  final ticket = ticketRepo.getById(encounter.ticketId);
  if (ticket == null) return null;
  final areaList = SeedData.clinicAreas.where((a) => a.id == ticket.destinationClinicAreaId).toList();
  final area = areaList.isEmpty ? null : areaList.first;
  return area?.departmentId;
}
