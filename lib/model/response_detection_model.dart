class TfLiteModel {
  final double confidence;
  final int index;
  final String label;

  TfLiteModel({
    required this.confidence,
    required this.index,
    required this.label,
  });
}
