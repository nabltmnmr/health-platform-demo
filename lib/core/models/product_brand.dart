/// Brand/company product under a national identifier.
class ProductBrand {
  const ProductBrand({
    required this.id,
    required this.productNationalId,
    required this.brandName,
    required this.companyName,
    this.batchIds = const [],
  });

  final String id;
  final String productNationalId;
  final String brandName;
  final String companyName;
  final List<String> batchIds;
}
