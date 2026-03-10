import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/enums/user_role.dart';
import '../doctor/doctor_dashboard_screen.dart';
import '../supervisor/supervisor_dashboard_screen.dart';
import '../registration/registration_dashboard_screen.dart';
import '../pharmacy/pharmacist_dashboard_screen.dart';
import '../lab/lab_tech_dashboard_screen.dart';
import '../nursing/nurse_dashboard_screen.dart';
import '../inventory/inventory_dashboard_screen.dart';
import '../supervisor/health_department_supervisor_dashboard_screen.dart';

/// Selects dashboard by selected demo mode and current user role.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(selectedDemoModeProvider);
    final user = ref.watch(currentUserProvider);
    final role = user?.role;

    if (mode == DemoMode.supplySupervision) {
      switch (role) {
        case UserRole.inventoryOfficer:
          return const InventoryDashboardScreen();
        case UserRole.supervisor:
          return const SupervisorDashboardScreen();
        default:
          return const SupervisorDashboardScreen();
      }
    }

    if (mode == DemoMode.healthDepartmentSupervisor) {
      return const HealthDepartmentSupervisorDashboardScreen();
    }

    // Patient Care mode
    switch (role) {
      case UserRole.registrationClerk:
        return const RegistrationDashboardScreen();
      case UserRole.doctor:
        return const DoctorDashboardScreen();
      case UserRole.pharmacist:
        return const PharmacistDashboardScreen();
      case UserRole.labTechnician:
        return const LabTechDashboardScreen();
      case UserRole.nurse:
        return const NurseDashboardScreen();
      default:
        return const DoctorDashboardScreen();
    }
  }
}
