/// Stock location (inventory, pharmacy area, etc.).
class StockLocation {
  const StockLocation({
    required this.id,
    required this.name,
    required this.facilityId,
    this.locationType,
  });

  final String id;
  final String name;
  final String facilityId;
  final String? locationType; // central, pharmacy, ward, etc.
}
