import '../models/models.dart';
import '../seed/seed_data.dart';

/// In-memory encounter repository for demo.
class EncounterRepository {
  EncounterRepository() {
    _encounters = List.from(SeedData.encounters);
    _diagnoses = List.from(SeedData.diagnoses);
  }

  late final List<Encounter> _encounters;
  late final List<Diagnosis> _diagnoses;

  List<Encounter> get all => List.unmodifiable(_encounters);
  List<Diagnosis> get allDiagnoses => List.unmodifiable(_diagnoses);

  Encounter? getById(String id) {
    try {
      return _encounters.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Encounter? getByTicketId(String ticketId) {
    try {
      return _encounters.firstWhere((e) => e.ticketId == ticketId);
    } catch (_) {
      return null;
    }
  }

  /// All encounters for a patient, for visit history / patient record.
  List<Encounter> getByPatientId(String patientId) {
    return _encounters.where((e) => e.patientId == patientId).toList();
  }

  List<Diagnosis> getDiagnosesByEncounter(String encounterId) {
    return _diagnoses.where((d) => d.encounterId == encounterId).toList();
  }

  void addEncounter(Encounter e) {
    _encounters.add(e);
  }

  void updateEncounter(Encounter e) {
    final i = _encounters.indexWhere((x) => x.id == e.id);
    if (i >= 0) _encounters[i] = e;
  }

  void addDiagnosis(Diagnosis d) {
    _diagnoses.add(d);
  }
}
