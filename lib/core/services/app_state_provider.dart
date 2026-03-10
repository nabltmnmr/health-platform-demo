import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositories/repositories.dart';
import '../models/models.dart';
import '../seed/seed_data.dart';

/// Repositories (singleton per app).
final patientRepositoryProvider = Provider<PatientRepository>((ref) => PatientRepository());
final ticketRepositoryProvider = Provider<TicketRepository>((ref) => TicketRepository());
final encounterRepositoryProvider = Provider<EncounterRepository>((ref) => EncounterRepository());
final pharmacyRepositoryProvider = Provider<PharmacyRepository>((ref) => PharmacyRepository());
final labRepositoryProvider = Provider<LabRepository>((ref) => LabRepository());
final nursingRepositoryProvider = Provider<NursingRepository>((ref) => NursingRepository());
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) => InventoryRepository());
final supervisionRepositoryProvider = Provider<SupervisionRepository>((ref) => SupervisionRepository());
final queueRepositoryProvider = Provider<QueueRepository>((ref) => QueueRepository());

/// Demo app state: current user (role), selected institute, demo mode.
final currentUserProvider = StateProvider<User?>((ref) => null);

final selectedInstituteProvider = StateProvider<Institute?>((ref) => null);

enum DemoMode { patientCare, supplySupervision, healthDepartmentSupervisor }

final selectedDemoModeProvider = StateProvider<DemoMode?>((ref) => null);

/// For Health Department Supervisor demo: which institute to focus on (null = all).
final selectedSupervisorInstituteIdProvider = StateProvider<String?>((ref) => null);

/// Selected facility (hospital or health center) for current user.
final selectedFacilityIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.facilityId;
});

/// Static seed data (read-only).
final institutesProvider = Provider<List<Institute>>((ref) => SeedData.institutes);
final hospitalsProvider = Provider<List<Hospital>>((ref) => SeedData.hospitals);
final healthCentersProvider = Provider<List<HealthCenter>>((ref) => SeedData.healthCenters);
final clinicAreasProvider = Provider<List<ClinicArea>>((ref) => SeedData.clinicAreas);
final pharmacyAreasProvider = Provider<List<PharmacyArea>>((ref) => SeedData.pharmacyAreas);
final labAreasProvider = Provider<List<LabArea>>((ref) => SeedData.labAreas);
final nursingAreasProvider = Provider<List<NursingArea>>((ref) => SeedData.nursingAreas);
final wardsProvider = Provider<List<Ward>>((ref) => SeedData.wards);
final demoUsersProvider = Provider<List<User>>((ref) => SeedData.users);
