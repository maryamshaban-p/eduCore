import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'summarize_model.dart';

class SummarizeRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/ai';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Authorization': 'Bearer $token',
      // NOTE: no Content-Type here — http.MultipartRequest sets its own
      // 'multipart/form-data; boundary=...' header automatically. Setting
      // it manually (like the JSON requests in this app do) would strip
      // the boundary and the server would fail to parse the file part.
    };
  }

  /// Uploads [pdfBytes] (the picked PDF's raw bytes) to
  /// POST /api/ai/summarize as multipart/form-data under the field name
  /// `pdf`, and returns the parsed { filename, summary } result.
  Future<SummarizeResultModel> summarizePdf({
    required List<int> pdfBytes,
    required String fileName,
  }) async {
    final uri = Uri.parse('$_baseUrl/summarize');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll(await _headers());

    request.files.add(
      http.MultipartFile.fromBytes(
        'pdf',
        pdfBytes,
        filename: fileName,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return SummarizeResultModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    } else {
      throw Exception('Failed to summarize the file. Please try again.'.tr());
    }
  }
}