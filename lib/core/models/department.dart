/// Department (ER, clinics, wards, etc.) within a hospital/health center.
class Department {
  const Department({
    required this.id,
    required this.name,
    required this.facilityId,
    required this.facilityType,
    this.clinicAreaIds = const [],
    this.pharmacyAreaIds = const [],
    this.labAreaIds = const [],
    this.nursingAreaIds = const [],
    this.wardIds = const [],
  });

  final String id;
  final String name;
  final String facilityId;
  final DepartmentFacilityType facilityType;
  final List<String> clinicAreaIds;
  final List<String> pharmacyAreaIds;
  final List<String> labAreaIds;
  final List<String> nursingAreaIds;
  final List<String> wardIds;
}

enum DepartmentFacilityType { hospital, healthCenter }
