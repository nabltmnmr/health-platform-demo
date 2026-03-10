/// Source of received supply (institute inventory).
enum SupplySourceType {
  transferFromInstitute,
  healthDepartmentSupply,
  thirdPartyPurchase,
}

extension SupplySourceTypeX on SupplySourceType {
  String get label {
    switch (this) {
      case SupplySourceType.transferFromInstitute:
        return 'Transfer from another institute';
      case SupplySourceType.healthDepartmentSupply:
        return 'Health department supply';
      case SupplySourceType.thirdPartyPurchase:
        return '3rd party purchase';
    }
  }
}
