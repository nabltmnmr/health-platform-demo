import '../models/models.dart';
import '../enums/enums.dart';
import '../seed/seed_data.dart';

/// In-memory pharmacy repository (prescriptions, dispensing areas).
class PharmacyRepository {
  PharmacyRepository() {
    _prescriptions = List.from(SeedData.prescriptions);
    _areas = List.from(SeedData.pharmacyAreas);
    _snapshots = _buildSnapshots();
  }

  late final List<Prescription> _prescriptions;
  late final List<PharmacyArea> _areas;
  late List<PharmacyStockSnapshot> _snapshots;

  List<Prescription> get allPrescriptions => List.unmodifiable(_prescriptions);
  List<PharmacyArea> get pharmacyAreas => List.unmodifiable(_areas);

  Prescription? getPrescriptionById(String id) {
    try {
      return _prescriptions.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Prescription> getPrescriptionsByEncounterId(String encounterId) {
    return _prescriptions.where((p) => p.encounterId == encounterId).toList();
  }

  List<Prescription> getPendingByPharmacyArea(String pharmacyAreaId) {
    return _prescriptions.where((p) =>
        p.pharmacyAreaId == pharmacyAreaId && p.status == PrescriptionStatus.pending).toList();
  }

  List<PharmacyStockSnapshot> getStockSnapshots(String pharmacyAreaId) {
    return _snapshots.where((s) => s.pharmacyAreaId == pharmacyAreaId).toList();
  }

  StockStatus stockStatusForProduct(String pharmacyAreaId, String productNationalId) {
    final snap = _snapshots.where((s) =>
        s.pharmacyAreaId == pharmacyAreaId && s.productNationalId == productNationalId).toList();
    if (snap.isEmpty) return StockStatus.unavailable;
    final total = snap.fold<int>(0, (sum, s) => sum + s.totalQuantity);
    if (total == 0) return StockStatus.outOfStock;
    final threshold = snap.first.lowStockThreshold ?? 20;
    if (total <= threshold) return StockStatus.lowStock;
    return StockStatus.available;
  }

  void updatePrescription(Prescription p) {
    final i = _prescriptions.indexWhere((x) => x.id == p.id);
    if (i >= 0) _prescriptions[i] = p;
  }

  void addPrescription(Prescription p) {
    _prescriptions.add(p);
  }

  List<PharmacyStockSnapshot> _buildSnapshots() {
    final batches = SeedData.stockBatches;
    final locationIds = _areas.map((a) => a.id).toSet();
    final byLocation = <String, Map<String, int>>{};
    for (final b in batches) {
      final locId = b.locationId;
      if (!locationIds.contains(locId)) continue;
      final brand = SeedData.productBrands.firstWhere((pb) => pb.id == b.productBrandId);
      final nationalId = brand.productNationalId;
      byLocation.putIfAbsent(locId, () => {});
      byLocation[locId]![nationalId] = (byLocation[locId]![nationalId] ?? 0) + b.quantity;
    }
    final list = <PharmacyStockSnapshot>[];
    final pharmacyLocationIds = _areas.map((a) => a.id).toSet();
    for (final entry in byLocation.entries) {
      if (!pharmacyLocationIds.contains(entry.key)) continue;
      for (final productEntry in entry.value.entries) {
        list.add(PharmacyStockSnapshot(
          pharmacyAreaId: entry.key,
          productNationalId: productEntry.key,
          totalQuantity: productEntry.value,
          lowStockThreshold: 20,
        ));
      }
    }
    return list;
  }
}
