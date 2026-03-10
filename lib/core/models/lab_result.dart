/// Lab result for a request.
class LabResult {
  const LabResult({
    required this.id,
    required this.labRequestId,
    this.value,
    this.unit,
    this.referenceRange,
    this.interpretation,
    this.completedAt,
    this.enteredById,
    this.resultImageBase64,
  });

  final String id;
  final String labRequestId;
  final String? value;
  final String? unit;
  final String? referenceRange;
  final String? interpretation;
  final DateTime? completedAt;
  final String? enteredById;
  /// Optional image of the test result (e.g. scan of lab report), stored as base64.
  final String? resultImageBase64;
}
