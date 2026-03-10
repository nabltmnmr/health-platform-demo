import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/seed/seed_data.dart';
import '../../../core/enums/enums.dart';
import '../../../shared/widgets/recommendation_card.dart';

class TransferRecommendationsScreen extends ConsumerWidget {
  const TransferRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(supervisionRepositoryProvider).transferSuggestions;
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);

    return PageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text(l10n.transferRecommendationsTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.transferRecommendationsSubtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          if (suggestions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: AppColors.success),
                    const SizedBox(height: 16),
                    Text(l10n.noPendingRecommendations, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            )
          else
            ...suggestions.map((t) {
              final product = invRepo.getNationalProduct(t.productNationalId);
              final sourceInst = SeedData.institutes.where((i) => i.id == t.sourceInstituteId).toList();
              final destInst = SeedData.institutes.where((i) => i.id == t.destinationInstituteId).toList();
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RecommendationCard(
                  productName: '${product?.name ?? t.productNationalId} ${product?.form ?? ''}',
                  summary: t.reasons.isNotEmpty ? t.reasons.first : '',
                  sourceName: sourceInst.isNotEmpty ? sourceInst.first.name : t.sourceInstituteId,
                  destinationName: destInst.isNotEmpty ? destInst.first.name : t.destinationInstituteId,
                  quantity: t.quantity,
                  reasonTags: [
                    if (t.shortageRelief) l10n.shortageRelief,
                    if (t.expiryPrevention) l10n.expiryPrevention,
                  ],
                  urgency: l10n.recommendationPriorityLabel(t.priority),
                  wastePrevented: t.estimatedWastePrevented,
                  wastePreventedLabel: t.estimatedWastePrevented != null ? l10n.estWastePrevented(t.estimatedWastePrevented!) : null,
                  quantityDisplay: '${l10n.quantityLabel}: ${t.quantity}',
                  onTap: () => context.push('/supply/transfer/${t.id}'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
