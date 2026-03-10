import '../models/models.dart';
import '../seed/seed_data.dart';

/// In-memory supervision repository (transfer suggestions, insights).
class SupervisionRepository {
  SupervisionRepository() {
    _transferSuggestions = List.from(SeedData.transferSuggestions);
    _demandSignals = List.from(SeedData.demandSignals);
  }

  late final List<TransferSuggestion> _transferSuggestions;
  late final List<DemandSignal> _demandSignals;

  List<TransferSuggestion> get transferSuggestions => List.unmodifiable(_transferSuggestions);
  List<DemandSignal> get demandSignals => List.unmodifiable(_demandSignals);

  List<TransferSuggestion> getSuggestionsByProduct(String productNationalId) {
    return _transferSuggestions.where((t) => t.productNationalId == productNationalId).toList();
  }

  List<DemandSignal> getDemandSignalsByLocation(String locationId) {
    return _demandSignals.where((d) => d.locationId == locationId).toList();
  }
}
