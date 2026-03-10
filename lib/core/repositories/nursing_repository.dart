import '../models/models.dart';
import '../seed/seed_data.dart';

/// In-memory nursing repository (treatment orders).
class NursingRepository {
  NursingRepository() {
    _orders = List.from(SeedData.treatmentOrders);
    _areas = List.from(SeedData.nursingAreas);
  }

  late final List<TreatmentOrder> _orders;
  late final List<NursingArea> _areas;

  List<TreatmentOrder> get allOrders => List.unmodifiable(_orders);
  List<NursingArea> get nursingAreas => List.unmodifiable(_areas);

  TreatmentOrder? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  List<TreatmentOrder> getByEncounter(String encounterId) {
    return _orders.where((o) => o.encounterId == encounterId).toList();
  }

  void addOrder(TreatmentOrder o) {
    _orders.add(o);
  }

  void updateOrder(TreatmentOrder o) {
    final i = _orders.indexWhere((x) => x.id == o.id);
    if (i >= 0) _orders[i] = o;
  }
}
