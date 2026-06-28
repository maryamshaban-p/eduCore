class SummarizeResultModel {
  final String filename;
  final String summary;

  SummarizeResultModel({
    required this.filename,
    required this.summary,
  });

  factory SummarizeResultModel.fromJson(Map<String, dynamic> json) {
    return SummarizeResultModel(
      filename: json['filename'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
    );
  }
}