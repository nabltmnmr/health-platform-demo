/// Stock availability status for display.
enum StockStatus {
  available,
  lowStock,
  outOfStock,
  unavailable,
}

extension StockStatusX on StockStatus {
  String get label {
    switch (this) {
      case StockStatus.available:
        return 'Available';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.unavailable:
        return 'Unavailable';
    }
  }
}
