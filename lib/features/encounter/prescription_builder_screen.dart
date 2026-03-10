import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/repositories/ticket_repository.dart';
import '../../../core/repositories/inventory_repository.dart';
import '../../../core/repositories/pharmacy_repository.dart';
import '../../../core/repositories/encounter_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/medication_availability_row.dart';

class PrescriptionBuilderScreen extends ConsumerStatefulWidget {
  const PrescriptionBuilderScreen({super.key, required this.ticketId, this.prescriptionId});

  final String ticketId;
  final String? prescriptionId;

  @override
  ConsumerState<PrescriptionBuilderScreen> createState() => _PrescriptionBuilderScreenState();
}

class _PrescriptionBuilderScreenState extends ConsumerState<PrescriptionBuilderScreen> {
  final _items = <_PrescriptionLine>[];
  String _pharmacyAreaId = 'pharm-er-a';
  bool _loadedForEdit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.prescriptionId != null && !_loadedForEdit) {
      _loadedForEdit = true;
      final rx = ref.read(pharmacyRepositoryProvider).getPrescriptionById(widget.prescriptionId!);
      if (rx != null) {
        _pharmacyAreaId = rx.pharmacyAreaId ?? _pharmacyAreaId;
        _items.clear();
        for (final i in rx.items) {
          _items.add(_PrescriptionLine(productId: i.productNationalId, qty: i.quantity, instructions: i.instructions));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final encounter = ref.watch(encounterRepositoryProvider).getByTicketId(widget.ticketId);
    if (encounter == null) return const Center(child: Text('Encounter not found'));

    final products = ref.watch(inventoryRepositoryProvider).nationalProducts;
    final pharmacyRepo = ref.watch(pharmacyRepositoryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Prescription Builder', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          Text('Prescribe by national identifier. Availability shown for selected pharmacy.', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            value: _pharmacyAreaId,
            decoration: const InputDecoration(labelText: 'Pharmacy'),
            items: SeedData.pharmacyAreas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
            onChanged: (v) => setState(() => _pharmacyAreaId = v ?? _pharmacyAreaId),
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._items.asMap().entries.map((e) => _buildLine(e.key, pharmacyRepo)),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => setState(() => _items.add(_PrescriptionLine(productId: '', qty: 1))),
            icon: const Icon(Icons.add),
            label: const Text('Add medication'),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _items.isEmpty ? null : () => _save(encounter),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(widget.prescriptionId != null ? 'Update Prescription' : 'Save Prescription'),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(int i, PharmacyRepository pharmacyRepo) {
    final line = _items[i];
    final products = ref.read(inventoryRepositoryProvider).nationalProducts;
    final match = products.where((p) => p.id == line.productId).toList();
    final product = match.isEmpty ? null : match.first;
    final status = product != null
        ? pharmacyRepo.stockStatusForProduct(_pharmacyAreaId, product.id)
        : StockStatus.unavailable;
    final statusEnum = status == StockStatus.available
        ? StockAvailabilityStatus.available
        : status == StockStatus.lowStock
            ? StockAvailabilityStatus.lowStock
            : StockAvailabilityStatus.unavailable;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Autocomplete<ProductNationalIdentifier>(
              key: ValueKey('product_$i\_${line.productId}'),
              initialValue: product != null
                  ? TextEditingValue(text: '${product.name} ${product.form}')
                  : null,
              displayStringForOption: (p) => '${p.name} ${p.form}',
              optionsBuilder: (value) {
                final query = value.text.trim().toLowerCase();
                if (query.isEmpty) return products.take(50);
                return products.where((p) {
                  final s = '${p.name} ${p.form}'.toLowerCase();
                  return s.contains(query);
                }).toList();
              },
              onSelected: (p) => setState(() => _items[i] = _PrescriptionLine(productId: p.id, qty: line.qty, instructions: line.instructions)),
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Product',
                    hintText: 'Type to search or tap to open list',
                  ),
                  onChanged: (v) {
                    final id = line.productId;
                    if (v.isEmpty && id.isNotEmpty) {
                      setState(() => _items[i] = _PrescriptionLine(productId: '', qty: line.qty, instructions: line.instructions));
                    }
                  },
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final p = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(p),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Text('${p.name} ${p.form}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            if (product != null)
              MedicationAvailabilityRow(
                productName: '${product.name} ${product.form}',
                stockStatus: statusEnum,
                alternativesCount: product.brandIds.length,
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: line.instructions,
                    decoration: const InputDecoration(labelText: 'Instructions'),
                    onChanged: (v) => setState(() => _items[i] = _PrescriptionLine(productId: line.productId, qty: line.qty, instructions: v)),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: '${line.qty}',
                    decoration: const InputDecoration(labelText: 'Qty'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() => _items[i] = _PrescriptionLine(productId: line.productId, qty: int.tryParse(v ?? '') ?? 1, instructions: line.instructions)),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => _items.removeAt(i)),
            ),
          ],
        ),
      ),
    );
  }

  void _save(Encounter encounter) {
    final valid = _items.where((l) => l.productId.isNotEmpty).toList();
    if (valid.isEmpty) return;

    final pharmacyRepo = ref.read(pharmacyRepositoryProvider);
    final isEdit = widget.prescriptionId != null;
    final rxId = isEdit ? widget.prescriptionId! : 'rx-${const Uuid().v4().substring(0, 8)}';
    final items = valid.map((l) => PrescriptionItem(id: 'rxi-${const Uuid().v4().substring(0, 6)}', prescriptionId: rxId, productNationalId: l.productId, quantity: l.qty, instructions: l.instructions)).toList();
    final rx = Prescription(id: rxId, encounterId: encounter.id, patientId: encounter.patientId, items: items, pharmacyAreaId: _pharmacyAreaId, createdAt: DateTime.now(), status: isEdit ? (pharmacyRepo.getPrescriptionById(rxId)?.status ?? PrescriptionStatus.pending) : PrescriptionStatus.pending);

    if (isEdit) {
      pharmacyRepo.updatePrescription(rx);
    } else {
      pharmacyRepo.addPrescription(rx);
      final ticket = ref.read(ticketRepositoryProvider).getById(widget.ticketId);
      if (ticket != null) {
        ref.read(ticketRepositoryProvider).update(VisitTicket(
          id: ticket.id, patientId: ticket.patientId, visitType: ticket.visitType, status: VisitStatus.awaitingPharmacy,
          queueNumber: ticket.queueNumber, destinationClinicAreaId: ticket.destinationClinicAreaId, facilityId: ticket.facilityId,
          qrPayload: ticket.qrPayload, encounterId: ticket.encounterId, createdAt: ticket.createdAt,
        ));
      }
      ref.read(encounterRepositoryProvider).updateEncounter(Encounter(
        id: encounter.id, ticketId: encounter.ticketId, patientId: encounter.patientId, providerId: encounter.providerId,
        diagnosisIds: encounter.diagnosisIds, prescriptionId: rxId, labRequestIds: encounter.labRequestIds, treatmentOrderIds: encounter.treatmentOrderIds,
        status: VisitStatus.awaitingPharmacy, startedAt: encounter.startedAt, endedAt: encounter.endedAt, notes: encounter.notes,
      ));
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? 'Prescription updated' : 'Prescription saved')));
      context.pop();
    }
  }
}

class _PrescriptionLine {
  _PrescriptionLine({required this.productId, required this.qty, this.instructions});
  final String productId;
  final int qty;
  final String? instructions;
}
