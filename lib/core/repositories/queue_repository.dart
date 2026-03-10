import '../models/models.dart';
import '../seed/seed_data.dart';

/// In-memory queue repository.
class QueueRepository {
  QueueRepository() {
    _entries = List.from(SeedData.queueEntries);
  }

  late final List<QueueEntry> _entries;

  List<QueueEntry> get all => List.unmodifiable(_entries);

  List<QueueEntry> getByArea(String areaId) {
    return _entries.where((e) => e.areaId == areaId).toList()..sort((a, b) => a.queueNumber.compareTo(b.queueNumber));
  }

  QueueEntry? getById(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(QueueEntry e) {
    _entries.add(e);
  }

  void update(QueueEntry e) {
    final i = _entries.indexWhere((x) => x.id == e.id);
    if (i >= 0) _entries[i] = e;
  }
}
