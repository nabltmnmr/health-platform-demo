import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../app/theme/radii.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/empty_state.dart';

class InventoryProductListScreen extends ConsumerStatefulWidget {
  const InventoryProductListScreen({super.key});

  @override
  ConsumerState<InventoryProductListScreen> createState() => _InventoryProductListScreenState();
}

class _InventoryProductListScreenState extends ConsumerState<InventoryProductListScreen> {
  final _query = ValueNotifier<String>('');

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    var products = invRepo.nationalProducts;
    return ValueListenableBuilder<String>(
      valueListenable: _query,
      builder: (context, q, _) {
        if (q.trim().isNotEmpty) {
          final lower = q.trim().toLowerCase();
          products = products.where((p) => p.name.toLowerCase().contains(lower) || p.form.toLowerCase().contains(lower)).toList();
        }
        return PageLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Products by National Identifier', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.md),
              AppSearchBar(hint: 'Search products...', onChanged: (v) => _query.value = v),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: products.isEmpty
                    ? const EmptyState(icon: Icons.inventory_2, title: 'No products')
                    : ListView.separated(
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final p = products[i];
                          return Material(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            child: InkWell(
                              onTap: () => context.push('/supply/product/${p.id}'),
                              borderRadius: BorderRadius.circular(AppRadii.md),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Row(
                                  children: [
                                    Icon(Icons.medication, color: AppColors.primary),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${p.name} ${p.form}', style: Theme.of(context).textTheme.titleSmall),
                                          Text('${p.brandIds.length} brand(s)', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
