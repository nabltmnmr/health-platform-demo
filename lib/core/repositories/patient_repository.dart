import '../models/models.dart';
import '../seed/seed_data.dart';

/// In-memory patient repository for demo.
class PatientRepository {
  PatientRepository() {
    _patients = List.from(SeedData.patients);
  }

  late final List<Patient> _patients;

  List<Patient> get all => List.unmodifiable(_patients);

  Patient? getById(String id) {
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Patient> searchByName(String query) {
    if (query.trim().isEmpty) return all;
    final q = query.trim().toLowerCase();
    return _patients.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  void add(Patient patient) {
    _patients.add(patient);
  }

  void update(Patient patient) {
    final i = _patients.indexWhere((p) => p.id == patient.id);
    if (i >= 0) _patients[i] = patient;
  }
}
