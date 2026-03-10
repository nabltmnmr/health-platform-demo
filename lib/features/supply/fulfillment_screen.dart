import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/fefo_warning_banner.dart';

class FulfillmentScreen extends ConsumerStatefulWidget {
  const FulfillmentScreen({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<FulfillmentScreen> createState() => _FulfillmentScreenState();
}

class _FulfillmentScreenState extends ConsumerState<FulfillmentScreen> {
  String? _selectedBatchId;

  @override
  Widget build(BuildContext context) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final requests = invRepo.supplyRequests.where((r) => r.id == widget.requestId).toList();
    if (requests.isEmpty) return const Center(child: Text('Request not found'));

    final request = requests.first;
    final product = invRepo.getNationalProduct(request.productNationalId);
    final reqLoc = SeedData.stockLocations.where((l) => l.id == request.requestingLocationId).toList();
    final reqLocName = reqLoc.isNotEmpty ? reqLoc.first.name : request.requestingLocationId;

    final centralLocs = SeedData.stockLocations.where((l) => l.locationType == 'central' || l.locationType == 'depot').toList();
    var batches = <StockBatch>[];
    for (final loc in centralLocs) {
      batches.addAll(invRepo.getBatchesForNationalProductAtLocation(request.productNationalId, loc.id));
    }
    batches.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    final fefoBatch = batches.isNotEmpty ? batches.first : null;
    _selectedBatchId ??= fefoBatch?.id;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Fulfill supply request', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${product?.name ?? request.productNationalId}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Requesting: $reqLocName', style: Theme.of(context).textTheme.bodyMedium),
                  Text('Quantity: ${request.quantity}', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (fefoBatch != null && _selectedBatchId != fefoBatch.id)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: FefoWarningBanner(
                message: 'Select earliest-expiry batch for FEFO compliance.',
                recommendedBatch: fefoBatch.batchNumber,
              ),
            ),
          Text('Select batch', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          ...batches.map((b) {
            final brandMatch = SeedData.productBrands.where((pb) => pb.id == b.productBrandId).toList();
            final brandName = brandMatch.isNotEmpty ? brandMatch.first.brandName : '';
            return RadioListTile<String>(
              title: Text('$brandName — ${b.batchNumber}'),
              subtitle: Text('Exp: ${DateFormat.yMd().format(b.expiryDate)} | Qty: ${b.quantity}'),
              value: b.id,
              groupValue: _selectedBatchId,
              onChanged: (v) => setState(() => _selectedBatchId = v),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: batches.isEmpty ? null : () => _fulfill(request),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Fulfill request'),
          ),
        ],
      ),
    );
  }

  void _fulfill(SupplyRequest request) {
    ref.read(inventoryRepositoryProvider).updateSupplyRequest(SupplyRequest(
      id: request.id, requestingLocationId: request.requestingLocationId, productNationalId: request.productNationalId,
      quantity: request.quantity, status: SupplyRequestStatus.fulfilled, fulfillmentIds: request.fulfillmentIds,
      requestedAt: request.requestedAt, notes: request.notes,
    ));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request fulfilled')));
      context.pop();
    }
  }
}
