import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../shared/widgets/page_layout.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/repositories/inventory_repository.dart';
import '../../../core/models/models.dart';
import '../../../core/enums/enums.dart';
import '../../../core/seed/seed_data.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_chip.dart';

class PharmacyStockScreen extends ConsumerStatefulWidget {
  const PharmacyStockScreen({super.key});

  @override
  ConsumerState<PharmacyStockScreen> createState() => _PharmacyStockScreenState();
}

class _PharmacyStockScreenState extends ConsumerState<PharmacyStockScreen> {
  String _areaId = 'pharm-er-a';

  @override
  Widget build(BuildContext context) {
    final invRepo = ref.watch(inventoryRepositoryProvider);
    final supRepo = ref.watch(supervisionRepositoryProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final areas = SeedData.pharmacyAreas;
    final stockLocations = SeedData.stockLocations;

    String tabLabel(PharmacyArea a) {
      final loc = stockLocations.where((l) => l.id == a.id).toList();
      if (loc.isNotEmpty) return loc.first.name;
      final dept = SeedData.departments.where((d) => d.id == a.departmentId).toList();
      if (dept.isEmpty) return a.name;
      final fid = dept.first.facilityId;
      final hosp = SeedData.hospitals.where((h) => h.id == fid).toList();
      if (hosp.isNotEmpty) return '${a.name} — ${hosp.first.name}';
      final hc = SeedData.healthCenters.where((c) => c.id == fid).toList();
      if (hc.isNotEmpty) return '${a.name} — ${hc.first.name}';
      return a.name;
    }

    final batchesByProduct = <String, int>{};
    final nearExpiryByProduct = <String, int>{};
    for (final b in invRepo.allBatches) {
      if (b.locationId != _areaId) continue;
      final brandList = SeedData.productBrands.where((pb) => pb.id == b.productBrandId).toList();
      final brand = brandList.isEmpty ? null : brandList.first;
      if (brand == null) continue;
      final pid = brand.productNationalId;
      batchesByProduct[pid] = (batchesByProduct[pid] ?? 0) + b.quantity;
      if (b.expiryRisk == ExpiryRiskLevel.high || b.expiryRisk == ExpiryRiskLevel.medium) {
        nearExpiryByProduct[pid] = (nearExpiryByProduct[pid] ?? 0) + b.quantity;
      }
    }

    final productIds = batchesByProduct.keys.toList();
    final lowStock = productIds.where((pid) => (batchesByProduct[pid] ?? 0) < 50).toList();
    final demandSignals = supRepo.demandSignals.where((d) => d.locationId == _areaId).toList();

    return PageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.pharmacyStockTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: areas.map((a) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(tabLabel(a)),
                  selected: _areaId == a.id,
                  onSelected: (_) => setState(() => _areaId = a.id),
                  selectedColor: AppColors.primaryContainer,
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: FilledButton.icon(
              onPressed: () => context.push('/supply/request-new?pharmacyId=$_areaId'),
              icon: const Icon(Icons.add_circle_outline),
              label: Text(l10n.requestSupplyFromInventory),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMySupplyRequests(invRepo, l10n),
                  if (lowStock.isNotEmpty) ...[
                    SectionCard(
                      title: l10n.lowStock,
                      child: Column(
                        children: lowStock.map((pid) {
                          final p = invRepo.getNationalProduct(pid);
                          return ListTile(
                            title: Text('${p?.name ?? pid}'),
                            trailing: StatusChip(label: '${batchesByProduct[pid]}', statusType: StatusChipType.warning, size: StatusChipSize.small),
                            onTap: () => context.push('/supply/product/$pid'),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (demandSignals.isNotEmpty) ...[
                    SectionCard(
                      title: l10n.demandSignals,
                      child: Column(
                        children: demandSignals.map((d) {
                          final p = invRepo.getNationalProduct(d.productNationalId);
                          return ListTile(
                            title: Text('${p?.name ?? d.productNationalId}'),
                            subtitle: Text(l10n.requestsCount(d.requestCount)),
                            trailing: const Icon(Icons.signal_cellular_alt, color: AppColors.danger),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  SectionCard(
                    title: l10n.currentStock,
                    child: productIds.isEmpty
                        ? Text(l10n.noStockInArea)
                        : Column(
                            children: productIds.map((pid) {
                              final p = invRepo.getNationalProduct(pid);
                              final qty = batchesByProduct[pid] ?? 0;
                              final nearQty = nearExpiryByProduct[pid] ?? 0;
                              return ListTile(
                                title: Text('${p?.name ?? pid} ${p?.form ?? ''}'),
                                subtitle: nearQty > 0 ? Text('$nearQty ${l10n.nearExpiryChip}') : null,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (nearQty > 0) StatusChip(label: l10n.nearExpiryChip, statusType: StatusChipType.warning, size: StatusChipSize.small),
                                    const SizedBox(width: 8),
                                    Text('$qty', style: Theme.of(context).textTheme.titleSmall),
                                  ],
                                ),
                                onTap: () => context.push('/supply/product/$pid'),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMySupplyRequests(InventoryRepository invRepo, AppLocalizations l10n) {
    final myRequests = invRepo.supplyRequests.where((r) => r.requestingLocationId == _areaId).toList();
    if (myRequests.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: SectionCard(
        title: l10n.mySupplyRequests,
        child: Column(
          children: myRequests.map((r) {
            final p = invRepo.getNationalProduct(r.productNationalId);
            return ListTile(
              title: Text('${p?.name ?? r.productNationalId}'),
              subtitle: Text('Qty: ${r.quantity}'),
              trailing: StatusChip(label: l10n.supplyRequestStatusLabel(r.status), size: StatusChipSize.small, statusType: r.status == SupplyRequestStatus.pending ? StatusChipType.warning : StatusChipType.success),
            );
          }).toList(),
        ),
      ),
    );
  }
}
