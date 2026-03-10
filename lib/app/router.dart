import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/shell/shell_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/demo_selector/demo_selector_screen.dart';
import '../features/institute_selector/institute_selector_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/patients/patient_search_screen.dart';
import '../features/patients/create_patient_screen.dart';
import '../features/tickets/ticket_creation_screen.dart';
import '../features/tickets/ticket_detail_screen.dart';
import '../features/queue/queue_screen.dart';
import '../features/doctor/doctor_dashboard_screen.dart';
import '../features/encounter/encounter_screen.dart';
import '../features/inventory/inventory_dashboard_screen.dart';
import '../features/inventory/inventory_product_list_screen.dart';
import '../features/inventory/national_identifier_detail_screen.dart';
import '../features/supply/supply_request_queue_screen.dart';
import '../features/supply/create_supply_request_screen.dart';
import '../features/supply/fulfillment_screen.dart';
import '../features/supply/receive_supply_screen.dart';
import '../features/supply/supply_receipt_history_screen.dart';
import '../features/supply/pharmacy_stock_screen.dart';
import '../features/supply/transfer_recommendations_screen.dart';
import '../features/supply/transfer_simulation_screen.dart';
import '../features/supply/institute_comparison_screen.dart';
import '../features/supply/analytics_screen.dart';
import '../features/encounter/prescription_builder_screen.dart';
import '../features/pharmacy/pharmacy_queue_screen.dart';
import '../features/pharmacy/pharmacy_dispense_screen.dart';
import '../features/lab/lab_queue_screen.dart';
import '../features/lab/lab_result_screen.dart';
import '../features/nursing/nursing_queue_screen.dart';
import '../features/nursing/treatment_admin_screen.dart';
import '../features/discharge/discharge_screen.dart';
import '../features/visit/visit_timeline_screen.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String demoSelector = 'demo-selector';
  static const String home = 'home';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/institute-selector', builder: (_, __) => const InstituteSelectorScreen()),
      GoRoute(path: '/demo-selector', builder: (_, __) => const DemoSelectorScreen()),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/patients', builder: (_, __) => const PatientSearchScreen()),
          GoRoute(path: '/patients/new', builder: (_, __) => const CreatePatientScreen()),
          GoRoute(
            path: '/tickets/new',
            builder: (_, state) {
              final patientId = state.uri.queryParameters['patientId'];
              return TicketCreationScreen(initialPatientId: patientId);
            },
          ),
          GoRoute(
            path: '/tickets/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return TicketDetailScreen(ticketId: id);
            },
          ),
          GoRoute(path: '/queue', builder: (_, __) => const QueueScreen()),
          GoRoute(path: '/doctor', builder: (_, __) => const DoctorDashboardScreen()),
          GoRoute(
            path: '/encounter/:ticketId',
            builder: (_, state) {
              final id = state.pathParameters['ticketId'] ?? '';
              return EncounterScreen(ticketId: id);
            },
          ),
          GoRoute(
            path: '/encounter/:ticketId/start',
            builder: (_, state) {
              final id = state.pathParameters['ticketId'] ?? '';
              return EncounterScreen(ticketId: id, startNew: true);
            },
          ),
          GoRoute(
            path: '/encounter/:ticketId/prescription',
            builder: (_, state) {
              final id = state.pathParameters['ticketId'] ?? '';
              return PrescriptionBuilderScreen(ticketId: id);
            },
          ),
          GoRoute(
            path: '/encounter/:ticketId/prescription/:prescriptionId',
            builder: (_, state) {
              final ticketId = state.pathParameters['ticketId'] ?? '';
              final prescriptionId = state.pathParameters['prescriptionId'] ?? '';
              return PrescriptionBuilderScreen(ticketId: ticketId, prescriptionId: prescriptionId);
            },
          ),
          GoRoute(path: '/pharmacy', builder: (_, __) => const PharmacyQueueScreen()),
          GoRoute(
            path: '/pharmacy/dispense/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return PharmacyDispenseScreen(prescriptionId: id);
            },
          ),
          GoRoute(path: '/lab', builder: (_, __) => const LabQueueScreen()),
          GoRoute(
            path: '/lab/result/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return LabResultScreen(requestId: id);
            },
          ),
          GoRoute(path: '/nursing', builder: (_, __) => const NursingQueueScreen()),
          GoRoute(
            path: '/nursing/administer/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return TreatmentAdminScreen(orderId: id);
            },
          ),
          GoRoute(
            path: '/discharge/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return DischargeScreen(ticketId: id);
            },
          ),
          GoRoute(
            path: '/visit-timeline/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return VisitTimelineScreen(ticketId: id);
            },
          ),
          // Demo Mode 2: Supply & Supervision
          GoRoute(path: '/supply/inventory', builder: (_, __) => const InventoryDashboardScreen()),
          GoRoute(path: '/supply/products', builder: (_, __) => const InventoryProductListScreen()),
          GoRoute(
            path: '/supply/product/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return NationalIdentifierDetailScreen(productId: id);
            },
          ),
          GoRoute(path: '/supply/requests', builder: (_, __) => const SupplyRequestQueueScreen()),
          GoRoute(path: '/supply/receive', builder: (_, __) => const ReceiveSupplyScreen()),
          GoRoute(path: '/supply/receipts', builder: (_, __) => const SupplyReceiptHistoryScreen()),
          GoRoute(
            path: '/supply/request-new',
            builder: (_, state) {
              final pharmacyId = state.uri.queryParameters['pharmacyId'] ?? 'pharm-er-a';
              return CreateSupplyRequestScreen(pharmacyId: pharmacyId);
            },
          ),
          GoRoute(
            path: '/supply/fulfill/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return FulfillmentScreen(requestId: id);
            },
          ),
          GoRoute(path: '/supply/pharmacy-stock', builder: (_, __) => const PharmacyStockScreen()),
          GoRoute(path: '/supply/recommendations', builder: (_, __) => const TransferRecommendationsScreen()),
          GoRoute(
            path: '/supply/transfer/:id',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              return TransferSimulationScreen(suggestionId: id);
            },
          ),
          GoRoute(path: '/supply/comparison', builder: (_, __) => const InstituteComparisonScreen()),
          GoRoute(
            path: '/supply/analytics',
            builder: (_, state) {
              final type = state.uri.queryParameters['type'] ?? 'lowStock';
              return AnalyticsScreen(analyticsType: type);
            },
          ),
        ],
      ),
    ],
  );
}
