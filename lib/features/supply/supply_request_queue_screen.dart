import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/enums/enums.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/supply_request_card.dart';
import '../../../shared/widgets/empty_state.dart';

class SupplyRequestQueueScreen extends ConsumerWidget {
  const SupplyRequestQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final pending = invRepo.getPendingSupplyRequests();

    return PageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.supplyRequestQueueTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.supplyRequestQueueSubtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: SectionCard(
              title: l10n.pendingRequests,
              expandChild: true,
              child: pending.isEmpty
                  ? EmptyState(
                      icon: Icons.inbox,
                      title: l10n.noPendingRequests,
                      message: l10n.noPendingRequestsMessage,
                    )
                  : ListView.separated(
                      itemCount: pending.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final r = pending[i];
                        final product = invRepo.getNationalProduct(r.productNationalId);
                        final loc = SeedData.stockLocations.where((l) => l.id == r.requestingLocationId).toList();
                        return SupplyRequestCard(
                          productName: '${product?.name ?? r.productNationalId}',
                          requestedQuantity: r.quantity,
                          requestingAreaName: loc.isNotEmpty ? loc.first.name : r.requestingLocationId,
                          statusLabel: l10n.supplyRequestStatusLabel(r.status),
                          onTap: () => context.push('/supply/fulfill/${r.id}'),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
