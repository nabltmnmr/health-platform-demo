/// User roles for demo role switching.
enum UserRole {
  registrationClerk,
  doctor,
  pharmacist,
  labTechnician,
  nurse,
  inventoryOfficer,
  supervisor,
}

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.registrationClerk:
        return 'Registration Clerk';
      case UserRole.doctor:
        return 'Doctor / HCP';
      case UserRole.pharmacist:
        return 'Pharmacist';
      case UserRole.labTechnician:
        return 'Lab Technician';
      case UserRole.nurse:
        return 'Nurse';
      case UserRole.inventoryOfficer:
        return 'Inventory Officer';
      case UserRole.supervisor:
        return 'Supervisor';
    }
  }
}
