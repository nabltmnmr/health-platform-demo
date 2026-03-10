/// National identifier — main prescribing and supervision identity.
class ProductNationalIdentifier {
  const ProductNationalIdentifier({
    required this.id,
    required this.name,
    required this.form,
    this.brandIds = const [],
  });

  final String id;
  final String name;
  final String form; // e.g. "500 mg capsule", "1 g vial"
  final List<String> brandIds;
}
