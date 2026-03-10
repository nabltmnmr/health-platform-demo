import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/repositories/inventory_repository.dart';
import '../../../shared/widgets/patient_header_card.dart';
import '../../../shared/widgets/fefo_warning_banner.dart';

class PharmacyDispenseScreen extends ConsumerStatefulWidget {
  const PharmacyDispenseScreen({super.key, required this.prescriptionId});

  final String prescriptionId;

  @override
  ConsumerState<PharmacyDispenseScreen> createState() => _PharmacyDispenseScreenState();
}

class _PharmacyDispenseScreenState extends ConsumerState<PharmacyDispenseScreen> {
  final _selectedBatch = <String, String>{}; // itemId -> batchId

  @override
  Widget build(BuildContext context) {
    final rx = ref.watch(pharmacyRepositoryProvider).getPrescriptionById(widget.prescriptionId);
    if (rx == null) return const Center(child: Text('Prescription not found'));

    final patient = ref.watch(patientRepositoryProvider).getById(rx.patientId);
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final pharmacyAreaId = rx.pharmacyAreaId ?? 'pharm-er-a';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (patient != null) ...[
            PatientHeaderCard(
              patientName: patient.name,
              age: patient.ageYears,
              sex: patient.sex,
              allergies: patient.allergies,
              medicalRecordNumber: patient.medicalRecordNumber,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          Text('Dispense', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          ...rx.items.map((item) {
            final product = invRepo.getNationalProduct(item.productNationalId);
            final batches = invRepo.getBatchesForNationalProductAtLocation(item.productNationalId, pharmacyAreaId);
            final fefoBatch = invRepo.getFefoBatch(item.productNationalId, pharmacyAreaId);
            final selected = _selectedBatch[item.id] ?? fefoBatch?.id;

            final selectedBatch = batches.where((b) => b.id == selected).toList();
            final showFefoWarning = selected != null && fefoBatch != null && selected != fefoBatch.id;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${product?.name ?? item.productNationalId} — Qty: ${item.quantity}', style: Theme.of(context).textTheme.titleSmall),
                    if (item.instructions != null) Text(item.instructions!, style: Theme.of(context).textTheme.bodySmall),
                    if (showFefoWarning && fefoBatch != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: FefoWarningBanner(
                          message: 'A batch with earlier expiry is available.',
                          recommendedBatch: fefoBatch.batchNumber,
                        ),
                      ),
                    if (batches.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ...batches.map((b) => RadioListTile<String>(
                        title: Text('${b.batchNumber} — Exp: ${b.expiryDate.day}/${b.expiryDate.month}/${b.expiryDate.year}'),
                        subtitle: Text('Qty: ${b.quantity}'),
                        value: b.id,
                        groupValue: selected,
                        onChanged: (v) => setState(() => _selectedBatch[item.id] = v ?? ''),
                      )),
                    ] else
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('No stock available', style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => _dispense(rx),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Confirm Dispense'),
          ),
        ],
      ),
    );
  }

  void _dispense(Prescription rx) {
    ref.read(pharmacyRepositoryProvider).updatePrescription(Prescription(
      id: rx.id, encounterId: rx.encounterId, patientId: rx.patientId, items: rx.items, status: PrescriptionStatus.dispensed,
      pharmacyAreaId: rx.pharmacyAreaId, createdAt: rx.createdAt,
    ));

    final invRepo = ref.read(inventoryRepositoryProvider);
    final nursingRepo = ref.read(nursingRepositoryProvider);
    final encounterRepo = ref.read(encounterRepositoryProvider);
    final existingOrders = nursingRepo.getByEncounter(rx.encounterId);
    final newOrderIds = <String>[];

    for (final item in rx.items) {
      final product = invRepo.getNationalProduct(item.productNationalId);
      final productName = product?.name ?? item.productNationalId;
      final productForm = product?.form ?? '';
      final description = item.instructions != null && item.instructions!.isNotEmpty
          ? '$productName $productForm — ${item.instructions}'
          : '$productName $productForm';
      final alreadyHasOrder = existingOrders.any((o) => o.description.toLowerCase().contains(productName.toLowerCase()));
      if (alreadyHasOrder) {
        for (final order in existingOrders) {
          if (order.description.toLowerCase().contains(productName.toLowerCase()) && !(order.medicationDispensed ?? false)) {
            nursingRepo.updateOrder(TreatmentOrder(
              id: order.id,
              encounterId: order.encounterId,
              patientId: order.patientId,
              description: order.description,
              dueAt: order.dueAt,
              status: order.status,
              administrationRecordIds: order.administrationRecordIds,
              notes: order.notes,
              medicationDispensed: true,
            ));
          }
        }
      } else {
        final treatId = 'treat-${rx.id}-${item.id}';
        final dueAt = DateTime.now().add(const Duration(minutes: 30));
        nursingRepo.addOrder(TreatmentOrder(
          id: treatId,
          encounterId: rx.encounterId,
          patientId: rx.patientId,
          description: description,
          dueAt: dueAt,
          status: TreatmentStatus.pending,
          medicationDispensed: true,
        ));
        newOrderIds.add(treatId);
      }
    }

    if (newOrderIds.isNotEmpty) {
      final encounter = encounterRepo.getById(rx.encounterId);
      if (encounter != null) {
        encounterRepo.updateEncounter(Encounter(
          id: encounter.id,
          ticketId: encounter.ticketId,
          patientId: encounter.patientId,
          providerId: encounter.providerId,
          diagnosisIds: encounter.diagnosisIds,
          prescriptionId: encounter.prescriptionId,
          labRequestIds: encounter.labRequestIds,
          treatmentOrderIds: [...encounter.treatmentOrderIds, ...newOrderIds],
          status: encounter.status,
          startedAt: encounter.startedAt,
          endedAt: encounter.endedAt,
          notes: encounter.notes,
        ));
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dispensed')));
      context.pop();
    }
  }
}
