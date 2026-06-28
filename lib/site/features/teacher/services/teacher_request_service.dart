import '../../../../core/services/api_service.dart';

class TeacherRequestService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> getRequests() async {
    final response = await _api.get('/teacher/pending-requests');
    return List<Map<String, dynamic>>.from(response.data);
  }

  // id is a GUID string
  Future<void> approveRequest(String requestId) async {
    await _api.post('/teacher/request/$requestId/approve', {});
  }

  Future<void> rejectRequest(String requestId) async {
    await _api.post('/teacher/request/$requestId/deny', {});
  }
}