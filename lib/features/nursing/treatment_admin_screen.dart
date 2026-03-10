import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/repositories/nursing_repository.dart';
import '../../../core/repositories/patient_repository.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';

class TreatmentAdminScreen extends ConsumerStatefulWidget {
  const TreatmentAdminScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<TreatmentAdminScreen> createState() => _TreatmentAdminScreenState();
}

class _TreatmentAdminScreenState extends ConsumerState<TreatmentAdminScreen> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(nursingRepositoryProvider).getOrderById(widget.orderId);
    if (order == null) return const Center(child: Text('Order not found'));

    final patient = ref.watch(patientRepositoryProvider).getById(order.patientId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(order.description, style: Theme.of(context).textTheme.headlineSmall),
          if (patient != null) Text(patient.name, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.xl),
          Text('Due: ${order.dueAt.toString().substring(0, 16)}', style: Theme.of(context).textTheme.bodyMedium),
          if ((order.medicationDispensed ?? false))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: AppColors.success),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Medication dispensed', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success)),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Administration notes'),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => _administer(order),
            style: FilledButton.styleFrom(backgroundColor: AppColors.success, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Mark Administered'),
          ),
        ],
      ),
    );
  }

  void _administer(TreatmentOrder order) {
    ref.read(nursingRepositoryProvider).updateOrder(TreatmentOrder(
      id: order.id, encounterId: order.encounterId, patientId: order.patientId, description: order.description,
      dueAt: order.dueAt, status: TreatmentStatus.administered, administrationRecordIds: order.administrationRecordIds,
      notes: _notesController.text.trim().isEmpty ? order.notes : _notesController.text.trim(),
      medicationDispensed: order.medicationDispensed ?? false,
    ));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked as administered')));
      context.pop();
    }
  }
}
