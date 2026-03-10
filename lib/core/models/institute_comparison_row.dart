/// Row for institute comparison table.
class InstituteComparisonRow {
  const InstituteComparisonRow({
    required this.productNationalId,
    required this.instituteId,
    this.instituteName,
    this.totalStock,
    this.lowStock = false,
    this.overstock = false,
    this.nearExpiryQuantity,
  });

  final String productNationalId;
  final String instituteId;
  final String? instituteName;
  final int? totalStock;
  final bool lowStock;
  final bool overstock;
  final int? nearExpiryQuantity;
}
