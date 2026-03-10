import '../models/models.dart';
import '../seed/seed_data.dart';

/// In-memory lab repository (requests, results).
class LabRepository {
  LabRepository() {
    _requests = List.from(SeedData.labRequests);
    _results = List.from(SeedData.labResults);
    _areas = List.from(SeedData.labAreas);
  }

  late final List<LabRequest> _requests;
  late final List<LabResult> _results;
  late final List<LabArea> _areas;

  List<LabRequest> get allRequests => List.unmodifiable(_requests);
  List<LabResult> get allResults => List.unmodifiable(_results);
  List<LabArea> get labAreas => List.unmodifiable(_areas);

  LabRequest? getRequestById(String id) {
    try {
      return _requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  LabResult? getResultById(String id) {
    try {
      return _results.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  LabResult? getResultByRequestId(String requestId) {
    try {
      return _results.firstWhere((r) => r.labRequestId == requestId);
    } catch (_) {
      return null;
    }
  }

  void addRequest(LabRequest r) {
    _requests.add(r);
  }

  void updateRequest(LabRequest r) {
    final i = _requests.indexWhere((x) => x.id == r.id);
    if (i >= 0) _requests[i] = r;
  }

  void addResult(LabResult r) {
    _results.add(r);
  }
}
