import '../models/models.dart';
import '../enums/enums.dart';
import '../seed/seed_data.dart';

/// In-memory ticket repository for demo.
class TicketRepository {
  TicketRepository() {
    _tickets = List.from(SeedData.visitTickets);
    _nextQueueNumber = _tickets.fold<int>(0, (m, t) => t.queueNumber > m ? t.queueNumber : m) + 1;
  }

  late final List<VisitTicket> _tickets;
  late int _nextQueueNumber;

  List<VisitTicket> get all => List.unmodifiable(_tickets);

  VisitTicket? getById(String id) {
    try {
      return _tickets.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<VisitTicket> getByFacility(String facilityId) {
    return _tickets.where((t) => t.facilityId == facilityId).toList();
  }

  List<VisitTicket> getByStatus(VisitStatus status) {
    return _tickets.where((t) => t.status == status).toList();
  }

  int getNextQueueNumber() => _nextQueueNumber++;

  void add(VisitTicket ticket) {
    _tickets.add(ticket);
  }

  void update(VisitTicket ticket) {
    final i = _tickets.indexWhere((t) => t.id == ticket.id);
    if (i >= 0) _tickets[i] = ticket;
  }
}
