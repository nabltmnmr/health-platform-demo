import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../app/theme/radii.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/seed/seed_data.dart';
import '../../../core/enums/enums.dart';
import '../../../shared/widgets/status_chip.dart';

class TransferSimulationScreen extends ConsumerWidget {
  const TransferSimulationScreen({super.key, required this.suggestionId});

  final String suggestionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(supervisionRepositoryProvider).transferSuggestions.where((t) => t.id == suggestionId).toList();
    if (suggestions.isEmpty) return const Center(child: Text('Recommendation not found'));

    final t = suggestions.first;
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final product = invRepo.getNationalProduct(t.productNationalId);
    final sourceInst = SeedData.institutes.where((i) => i.id == t.sourceInstituteId).toList();
    final destInst = SeedData.institutes.where((i) => i.id == t.destinationInstituteId).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Transfer simulation', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.lg),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${product?.name ?? t.productNationalId} ${product?.form ?? ''}', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(width: 8),
                    StatusChip(label: t.priority.label, statusType: StatusChipType.warning),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _row(context, 'Quantity', '${t.quantity}'),
                _row(context, 'From', sourceInst.isNotEmpty ? sourceInst.first.name : t.sourceInstituteId),
                _row(context, 'To', destInst.isNotEmpty ? destInst.first.name : t.destinationInstituteId),
                if (t.estimatedWastePrevented != null)
                  _row(context, 'Est. waste prevented', '${t.estimatedWastePrevented} units'),
                const SizedBox(height: AppSpacing.lg),
                ...t.reasons.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(r, style: Theme.of(context).textTheme.bodyMedium),
                    )),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transfer simulated — demo mode')));
              context.pop();
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Simulate transfer'),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
