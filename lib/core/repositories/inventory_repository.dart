import '../models/models.dart';
import '../enums/enums.dart';
import '../seed/seed_data.dart';

/// In-memory inventory repository (batches, locations, supply requests).
class InventoryRepository {
  InventoryRepository() {
    _batches = List.from(SeedData.stockBatches);
    _locations = List.from(SeedData.stockLocations);
    _supplyRequests = List.from(SeedData.supplyRequests);
    _supplyReceipts = List.from(SeedData.supplyReceipts);
    _nationalProducts = List.from(SeedData.productNationalIdentifiers);
    _brands = List.from(SeedData.productBrands);
  }

  late final List<StockBatch> _batches;
  late final List<StockLocation> _locations;
  late final List<SupplyRequest> _supplyRequests;
  late final List<SupplyReceipt> _supplyReceipts;
  late final List<ProductNationalIdentifier> _nationalProducts;
  late final List<ProductBrand> _brands;

  List<StockBatch> get allBatches => List.unmodifiable(_batches);
  List<StockLocation> get allLocations => List.unmodifiable(_locations);
  List<SupplyRequest> get supplyRequests => List.unmodifiable(_supplyRequests);
  List<SupplyReceipt> get supplyReceipts => List.unmodifiable(_supplyReceipts);
  List<ProductNationalIdentifier> get nationalProducts => List.unmodifiable(_nationalProducts);
  List<ProductBrand> get brands => List.unmodifiable(_brands);

  ProductNationalIdentifier? getNationalProduct(String id) {
    try {
      return _nationalProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ProductBrand> getBrandsByNationalId(String productNationalId) {
    return _brands.where((b) => b.productNationalId == productNationalId).toList();
  }

  List<StockBatch> getBatchesByBrand(String productBrandId) {
    return _batches.where((b) => b.productBrandId == productBrandId).toList();
  }

  List<StockBatch> getBatchesByLocation(String locationId) {
    return _batches.where((b) => b.locationId == locationId && b.quantity > 0).toList();
  }

  List<StockBatch> getBatchesForNationalProductAtLocation(String productNationalId, String locationId) {
    final brandIds = getBrandsByNationalId(productNationalId).map((b) => b.id).toSet();
    return _batches.where((b) =>
        brandIds.contains(b.productBrandId) && b.locationId == locationId && b.quantity > 0).toList();
  }

  StockBatch? getFefoBatch(String productNationalId, String locationId) {
    final batches = getBatchesForNationalProductAtLocation(productNationalId, locationId);
    if (batches.isEmpty) return null;
    batches.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    return batches.first;
  }

  List<SupplyRequest> getPendingSupplyRequests() {
    return _supplyRequests.where((r) => r.status == SupplyRequestStatus.pending).toList();
  }

  void updateBatch(StockBatch b) {
    final i = _batches.indexWhere((x) => x.id == b.id);
    if (i >= 0) _batches[i] = b;
  }

  void updateSupplyRequest(SupplyRequest r) {
    final i = _supplyRequests.indexWhere((x) => x.id == r.id);
    if (i >= 0) _supplyRequests[i] = r;
  }

  void addSupplyRequest(SupplyRequest r) {
    _supplyRequests.add(r);
  }

  void addBatch(StockBatch b) {
    _batches.add(b);
  }

  void addSupplyReceipt(SupplyReceipt r) {
    _supplyReceipts.add(r);
  }

  void addBrand(ProductBrand b) {
    _brands.add(b);
  }

  void updateNationalProduct(ProductNationalIdentifier p) {
    final i = _nationalProducts.indexWhere((x) => x.id == p.id);
    if (i >= 0) _nationalProducts[i] = p;
  }

  /// Find brand by national product and brand name (case-insensitive), or null.
  ProductBrand? findBrandByNationalIdAndName(String productNationalId, String brandName) {
    final name = brandName.trim().toLowerCase();
    if (name.isEmpty) return null;
    final list = _brands.where((b) => b.productNationalId == productNationalId && b.brandName.toLowerCase() == name).toList();
    return list.isEmpty ? null : list.first;
  }

  /// All supply receipts sorted by date descending (newest first).
  List<SupplyReceipt> getSupplyReceiptsSortedByDate() {
    final list = List<SupplyReceipt>.from(_supplyReceipts);
    list.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    return list;
  }

  /// Supply receipts filtered by supplier name (contains, case insensitive).
  List<SupplyReceipt> getSupplyReceiptsBySupplier(String supplierQuery) {
    if (supplierQuery.trim().isEmpty) return getSupplyReceiptsSortedByDate();
    final q = supplierQuery.trim().toLowerCase();
    final list = _supplyReceipts.where((r) => r.supplierName.toLowerCase().contains(q)).toList();
    list.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    return list;
  }
}
