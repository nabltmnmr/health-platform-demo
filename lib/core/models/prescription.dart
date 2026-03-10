import '../enums/enums.dart';
import 'prescription_item.dart';

/// Prescription for a visit.
class Prescription {
  const Prescription({
    required this.id,
    required this.encounterId,
    required this.patientId,
    required this.items,
    this.status = PrescriptionStatus.pending,
    this.pharmacyAreaId,
    this.createdAt,
  });

  final String id;
  final String encounterId;
  final String patientId;
  final List<PrescriptionItem> items;
  final PrescriptionStatus status;
  final String? pharmacyAreaId;
  final DateTime? createdAt;
}
