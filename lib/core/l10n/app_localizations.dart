import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/user_role.dart';
import '../enums/recommendation_priority.dart';
import '../enums/supply_request_status.dart';
import '../enums/queue_status.dart';
import '../services/locale_provider.dart';
import '../../shared/utils/queue_location_helper.dart';

/// Centralized EN/AR strings for the demo. Use via [appLocalizationsProvider].
class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  bool get isAr => locale.languageCode == 'ar';

  // App & shell
  String get appTitle => isAr ? 'تجربة منصة الصحة' : 'Health Platform Demo';
  String get appTitleShort => isAr ? 'منصة الصحة' : 'Health Platform Demo';
  String get menu => isAr ? 'القائمة' : 'Menu';
  String get back => isAr ? 'رجوع' : 'Back';
  String get notifications => isAr ? 'الإشعارات' : 'Notifications';
  String get account => isAr ? 'الحساب' : 'Account';
  String get switchDemo => isAr ? 'تبديل التجربة' : 'Switch demo';

  // Shell mode titles
  String get modePatientCare => isAr ? 'رعاية المرضى' : 'Patient Care';
  String get modeSupplySupervision => isAr ? 'المخزون والإشراف' : 'Supply & Supervision';
  String get modeHealthDeptSupervisor => isAr ? 'مشرف قسم الصحة' : 'Health Dept Supervisor';

  // Nav — Patient care
  String get navDashboard => isAr ? 'لوحة التحكم' : 'Dashboard';
  String get navPatients => isAr ? 'المرضى' : 'Patients';
  String get navQueue => isAr ? 'قائمة الانتظار' : 'Queue';
  String get navPharmacy => isAr ? 'الصيدلية' : 'Pharmacy';
  String get navLab => isAr ? 'المختبر' : 'Lab';
  String get navNursing => isAr ? 'التمريض' : 'Nursing';

  // Nav — Supply
  String get navSupervisor => isAr ? 'المشرف' : 'Supervisor';
  String get navInventory => isAr ? 'المخزون' : 'Inventory';
  String get navSupply => isAr ? 'التوريد' : 'Supply';
  String get navPharmacyStock => isAr ? 'مخزون الصيدلية' : 'Pharmacy Stock';
  String get navRecommendations => isAr ? 'التوصيات' : 'Recommendations';

  // Login
  String get loginSubtitle => isAr ? 'جرّب المنصة كعضو في الفريق' : 'Experience the platform as a staff member';
  String get loginTip => isAr
      ? 'نصيحة: د. عمر لرعاية المرضى • رانيا أو كريم للمخزون والإشراف'
      : 'Tip: Dr. Omar for Patient Care • Rania or Karim for Supply & Supervision';

  // Demo selector
  String get chooseDemo => isAr ? 'اختر التجربة' : 'Choose your demo';
  String get patientCareFlowTitle => isAr ? 'رعاية المرضى' : 'Patient Care Flow';
  String get patientCareFlowSubtitle => isAr
      ? 'تتبع الزيارة من قائمة الانتظار حتى الخروج. أحمد في الطوارئ مع التهاب تنفسي — شاهد مسار الرعاية الكامل.'
      : 'Follow a visit from queue to discharge. Ahmed is in the ER with a respiratory infection — see the full care path.';
  String get patientCareFlowHint => isAr
      ? 'جرّب: قائمة الانتظار → تذكرة → المقابلة → الصيدلية'
      : 'Try: Queue → Open ticket → Encounter → Prescribe → Pharmacy';
  String get supplyFlowTitle => isAr ? 'المخزون والإشراف' : 'Supply & Supervision Flow';
  String get supplyFlowSubtitle => isAr
      ? 'وازن المخزون بين المعاهد. صيدلية الطوارئ ب تحتاج سيفترياكسون — نفّذ باستخدام FEFO واستكشف اقتراحات النقل بالذكاء الاصطناعي.'
      : 'Balance stock across institutes. ER Pharmacy B needs Ceftriaxone — fulfill using FEFO and explore AI transfer suggestions.';
  String get supplyFlowHint => isAr
      ? 'جرّب: طلبات التوريد → التنفيذ → توصيات النقل'
      : 'Try: Supply requests → Fulfill → Transfer recommendations';
  String get healthDeptTitle => isAr ? 'مشرف قسم الصحة' : 'Health Department Supervisor';
  String get healthDeptSubtitle => isAr
      ? 'أشر على جميع المعاهد. اختر معهداً، اعرض تقارير الفائض والنقص والمنتجات المفقودة، قارن المعاهد، وقرر النقل مع الذكاء الاصطناعي.'
      : 'Supervise all institutes. Select an institute, view overstock, understock & missing reports, compare institutes, and decide transfers with AI.';
  String get healthDeptHint => isAr
      ? 'جرّب: اختر معهد → التقارير → المقارنة → توصيات الذكاء الاصطناعي'
      : 'Try: Select institute → Reports → Compare → AI recommendations';

  // Institute selector
  String get selectInstitute => isAr ? 'اختر المعهد' : 'Select institute';
  String get chooseInstituteForDemo => isAr ? 'اختر المعهد لهذه التجربة' : 'Choose the institute for this demo';
  String hospitalsCount(int n) => isAr ? '$n مستشفى' : '$n hospital(s)';
  String healthCentersCount(int n) => isAr ? '$n مركز صحي' : '$n health center(s)';
  String get instituteCounts => isAr ? 'مستشفى، مراكز صحية' : 'hospital(s), health center(s)';
  String institutesSummary(int hospitals, int healthCenters) =>
      isAr ? '$hospitals مستشفى، $healthCenters مركز صحي' : '$hospitals hospital(s), $healthCenters health center(s)';

  // Health Department Supervisor dashboard
  String get healthDeptSupervisorTitle => isAr ? 'مشرف قسم الصحة' : 'Health Department Supervisor';
  String get healthDeptSupervisorSubtitle => isAr
      ? 'أشر على جميع المعاهد — تقارير الفائض والنقص والمفقود، المقارنة، وتوصيات النقل بالذكاء الاصطناعي'
      : 'Supervise all institutes — overstock, understock, missing reports, compare, and AI transfer recommendations';
  String get allInstitutes => isAr ? 'جميع المعاهد' : 'All institutes';
  String get understockItems => isAr ? 'عناصر نقص المخزون' : 'Understock items';
  String get overstockItems => isAr ? 'عناصر فائض المخزون' : 'Overstock items';
  String get nearExpiry => isAr ? 'قرب الانتهاء' : 'Near expiry';
  String get aiRecommendations => isAr ? 'توصيات الذكاء الاصطناعي' : 'AI recommendations';
  String get compareInstitutes => isAr ? 'مقارنة المعاهد' : 'Compare institutes';
  String get compareInstitutesSubtitle => isAr
      ? 'توازن المخزون بين الشبكة المركزية والشمالية'
      : 'Stock balance across Central & Northern Health';
  String get compareInstitutesSubtitleShort => isAr ? 'المخزون عبر المعاهد' : 'Stock across institutes';
  String get aiTransferRecommendations => isAr ? 'توصيات نقل الذكاء الاصطناعي' : 'AI transfer recommendations';
  String get aiTransferRecommendationsSubtitle => isAr
      ? 'قرر النقل بين المعاهد بالذكاء الاصطناعي'
      : 'Decide transfers between institutes with AI';
  String get aiTransferRecommendationsSubtitleShort => isAr ? 'قرر النقل بالذكاء الاصطناعي' : 'Decide transfers with AI';
  String get topAiRecommendations => isAr ? 'أهم توصيات الذكاء الاصطناعي' : 'Top AI recommendations';
  String get noRecommendations => isAr ? 'لا توجد توصيات' : 'No recommendations';
  String get shortageRelief => isAr ? 'تخفيف النقص' : 'Shortage relief';
  String get expiryPrevention => isAr ? 'منع الانتهاء' : 'Expiry prevention';
  String get understockShort => isAr ? 'نقص المخزون' : 'Understock';
  String get overstockShort => isAr ? 'فائض المخزون' : 'Overstock';

  // Splash
  String get splashTagline => isAr ? 'رعاية المرضى وسلسلة التوريد في منصة واحدة' : 'Patient care & supply chain in one platform';
  String get roleRegistrationClerk => isAr ? 'موظف الاستقبال' : 'Registration Clerk';
  String get roleDoctor => isAr ? 'طبيب / مقدم رعاية' : 'Doctor / HCP';
  String get rolePharmacist => isAr ? 'دكتور صيدلاني' : 'Pharmacist';
  String get roleLabTechnician => isAr ? 'فني مختبر' : 'Lab Technician';
  String get roleNurse => isAr ? 'ممرض/ة' : 'Nurse';
  String get roleInventoryOfficer => isAr ? 'مسؤول المخزون' : 'Inventory Officer';
  String get roleSupervisor => isAr ? 'مشرف' : 'Supervisor';

  String roleLabel(UserRole role) {
    switch (role) {
      case UserRole.registrationClerk:
        return roleRegistrationClerk;
      case UserRole.doctor:
        return roleDoctor;
      case UserRole.pharmacist:
        return rolePharmacist;
      case UserRole.labTechnician:
        return roleLabTechnician;
      case UserRole.nurse:
        return roleNurse;
      case UserRole.inventoryOfficer:
        return roleInventoryOfficer;
      case UserRole.supervisor:
        return roleSupervisor;
    }
  }

  String recommendationPriorityLabel(RecommendationPriority p) {
    switch (p) {
      case RecommendationPriority.low:
        return isAr ? 'منخفض' : 'Low';
      case RecommendationPriority.medium:
        return isAr ? 'متوسط' : 'Medium';
      case RecommendationPriority.high:
        return isAr ? 'عالي' : 'High';
      case RecommendationPriority.urgent:
        return isAr ? 'عاجل' : 'Urgent';
    }
  }

  // Inventory dashboard
  String get inventoryDashboardTitle => isAr ? 'لوحة المخزون' : 'Inventory Dashboard';
  String get inventoryDashboardSubtitle => isAr ? 'صحة المخزون، التنبيهات، وطلبات التوريد' : 'Stock health, alerts, and supply requests';
  String get productList => isAr ? 'قائمة المنتجات' : 'Product list';
  String get productListSubtitle => isAr ? 'عرض بالمعرف الوطني' : 'View by national identifier';
  String get supplyRequests => isAr ? 'طلبات التوريد' : 'Supply requests';
  String get supplyRequestsSubtitle => isAr ? 'تنفيذ طلبات الصيدليات' : 'Fulfill pharmacy requests';
  String get receiveSupply => isAr ? 'استلام التوريد' : 'Receive supply';
  String get receiveSupplySubtitle => isAr ? 'تسجيل المخزون من النقل أو قسم الصحة أو طرف ثالث' : 'Register stock from transfer, health dept, or 3rd party';
  String get receivedSupplies => isAr ? 'المورّد المستلم' : 'Received supplies';
  String get receivedSuppliesSubtitle => isAr ? 'عرض السجل حسب المورّد والتاريخ' : 'View history by supplier and date';
  String get lowStockAlerts => isAr ? 'تنبيهات نقص المخزون' : 'Low stock alerts';
  String get pendingRequests => isAr ? 'طلبات قيد الانتظار' : 'Pending requests';

  // Supply request queue
  String get supplyRequestQueueTitle => isAr ? 'قائمة طلبات التوريد' : 'Supply Request Queue';
  String get supplyRequestQueueSubtitle => isAr
      ? 'استلام والموافقة على طلبات التوريد من صيدليات الطوارئ والأجنحة والعيادات. التنفيذ باستخدام FEFO.'
      : 'Receive and approve supply requests from ER, Wards, Day Clinic, and Night Clinic pharmacies. Fulfill using FEFO.';
  String get noPendingRequests => isAr ? 'لا توجد طلبات قيد الانتظار' : 'No pending requests';
  String get noPendingRequestsMessage => isAr
      ? 'في التجربة، طلبت صيدلية الزهراء الطوارئ والشبكة الشمالية توريدات.'
      : 'In the demo, Al-Zahra ER Pharmacy and Northern Regional have requested supplies.';

  // Pharmacy stock
  String get pharmacyStockTitle => isAr ? 'مخزون الصيدلية' : 'Pharmacy stock';
  String get requestSupplyFromInventory => isAr ? 'طلب توريد من المخزون' : 'Request supply from inventory';
  String get currentStock => isAr ? 'المخزون الحالي' : 'Current stock';
  String get lowStock => isAr ? 'نقص المخزون' : 'Low stock';
  String get noStockInArea => isAr ? 'لا يوجد مخزون في هذه المنطقة' : 'No stock in this area';
  String get mySupplyRequests => isAr ? 'طلبات التوريد الخاصة بي' : 'My supply requests';
  String get demandSignals => isAr ? 'إشارات الطلب' : 'Demand signals';
  String requestsCount(int n) => isAr ? '$n طلب' : '$n request(s)';
  String get nearExpiryChip => isAr ? 'قرب الانتهاء' : 'Near expiry';

  // Transfer recommendations
  String get transferRecommendationsTitle => isAr ? 'توصيات النقل' : 'Transfer recommendations';
  String get transferRecommendationsSubtitle => isAr
      ? 'إعادة التوزيع بالذكاء الاصطناعي لتخفيف النقص ومنع الانتهاء'
      : 'AI redistribution to relieve shortages and prevent expiry';
  String get noPendingRecommendations => isAr ? 'لا توجد توصيات قيد الانتظار' : 'No pending recommendations';
  String estWastePrevented(int n) => isAr ? 'تقدير الهدر الممنوع: $n وحدة' : 'Est. waste prevented: $n units';
  String get quantityLabel => isAr ? 'الكمية' : 'Quantity';

  // Pharmacy dashboard
  String get pharmacyDashboardTitle => isAr ? 'لوحة الصيدلية' : 'Pharmacy Dashboard';
  String get pharmacyDashboardSubtitle => isAr ? 'وصفات قيد الانتظار والمخزون' : 'Pending prescriptions and stock';
  String get pendingPrescriptions => isAr ? 'وصفات قيد الانتظار' : 'Pending prescriptions';
  String get lowStockItems => isAr ? 'عناصر نقص المخزون' : 'Low stock items';
  String get prescriptionQueue => isAr ? 'قائمة الوصفات' : 'Prescription queue';
  String get prescriptionQueueSubtitle => isAr ? 'صرف الوصفات المعلقة' : 'Dispense pending prescriptions';
  String get dispensePending => isAr ? 'صرف المعلّق' : 'Dispense pending';

  // Patients
  String get searchByPatientName => isAr ? 'البحث باسم المريض...' : 'Search by patient name...';
  String get newPatient => isAr ? 'مريض جديد' : 'New Patient';
  String get noPatients => isAr ? 'لا يوجد مرضى' : 'No patients';
  String get noMatches => isAr ? 'لا توجد نتائج' : 'No matches';
  String get createPatientToGetStarted => isAr ? 'أنشئ مريضاً للبدء' : 'Create a new patient to get started';
  String get tryDifferentSearch => isAr ? 'جرّب كلمة بحث أخرى' : 'Try a different search term';
  String get createPatient => isAr ? 'إنشاء مريض' : 'Create Patient';

  // Queue
  String get queueTitle => isAr ? 'قائمة الانتظار' : 'Queue';
  String get queueEmpty => isAr ? 'القائمة فارغة' : 'Queue empty';
  String get noPatientsInQueue => isAr ? 'لا يوجد مرضى في القائمة لهذه المنطقة' : 'No patients in queue for this area';
  String get noClinicAreas => isAr ? 'لا توجد مناطق عيادات لهذا المرفق' : 'No clinic areas for this facility';

  // Lab queue
  String get labQueueTitle => isAr ? 'قائمة المختبر' : 'Lab Queue';
  String get all => isAr ? 'الكل' : 'All';
  String get noPendingTests => isAr ? 'لا توجد تحاليل معلقة' : 'No pending tests';
  String get noMatchingPatients => isAr ? 'لا يوجد مرضى مطابقون' : 'No matching patients';

  // Nursing queue
  String get nursingQueueTitle => isAr ? 'قائمة التمريض' : 'Nursing Queue';
  String get noPendingTreatments => isAr ? 'لا توجد علاجات معلقة' : 'No pending treatments';
  String get dueTreatments => isAr ? 'العلاجات المستحقة' : 'Due treatments';

  // Supply request status
  String supplyRequestStatusLabel(SupplyRequestStatus s) {
    switch (s) {
      case SupplyRequestStatus.pending:
        return isAr ? 'قيد الانتظار' : 'Pending';
      case SupplyRequestStatus.approved:
        return isAr ? 'موافق عليه' : 'Approved';
      case SupplyRequestStatus.fulfilled:
        return isAr ? 'منفّذ' : 'Fulfilled';
      case SupplyRequestStatus.partial:
        return isAr ? 'منفّذ جزئياً' : 'Partially Fulfilled';
      case SupplyRequestStatus.cancelled:
        return isAr ? 'ملغى' : 'Cancelled';
    }
  }

  // Queue status
  String queueStatusLabel(QueueStatus s) {
    switch (s) {
      case QueueStatus.waiting:
        return isAr ? 'في الانتظار' : 'Waiting';
      case QueueStatus.called:
        return isAr ? 'تم الاستدعاء' : 'Called';
      case QueueStatus.inProgress:
        return isAr ? 'قيد التنفيذ' : 'In Progress';
      case QueueStatus.completed:
        return isAr ? 'مكتمل' : 'Completed';
      case QueueStatus.skipped:
        return isAr ? 'تم تخطيه' : 'Skipped';
    }
  }

  // Queue location category (ER, Clinics, Wards)
  String queueLocationCategoryLabel(QueueLocationCategory c) {
    switch (c) {
      case QueueLocationCategory.er:
        return isAr ? 'الطوارئ' : 'ER';
      case QueueLocationCategory.clinics:
        return isAr ? 'العيادات' : 'Clinics';
      case QueueLocationCategory.wards:
        return isAr ? 'الأجنحة' : 'Wards';
    }
  }
}

/// Provider that exposes [AppLocalizations] for the current locale.
final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  final locale = ref.watch(localeProvider);
  return AppLocalizations(locale);
});
