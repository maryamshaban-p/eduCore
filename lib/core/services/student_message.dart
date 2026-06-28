import 'package:edulink_app/core/services/api_sevice_student.dart';
import 'package:edulink_app/core/services/student_chat_model.dart';

class StudentMessageService {
  final ApiService _api = ApiService();

  /// GET /api/student/messages
  Future<List<StudentConversation>> getConversationsList() async {
    final response = await _api.get('/student/messages');
    return (response.data as List)
        .map((item) => StudentConversation.fromJson(item))
        .toList();
  }

  /// GET /api/student/messages/{partnerId}
  ///
  /// [partnerId] is the moderator/teacher's userId — the same value
  /// returned as `partnerId` by getConversationsList().
  Future<List<StudentChatMessage>> getConversation(String partnerId) async {
    final response = await _api.get('/student/messages/$partnerId');
    return (response.data as List)
        .map((item) => StudentChatMessage.fromJson(item))
        .toList();
  }

  /// POST /api/student/messages/{receiverId}
  ///
  /// The API only echoes back {id, sentAt} — not the message content.
  /// Use [content] locally (e.g. to build an optimistic StudentChatMessage
  /// with isMine: true) rather than expecting it in the response.
  Future<SendMessageResult> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    final response = await _api.post('/student/messages/$receiverId', {
      'content': content,
    });
    return SendMessageResult.fromJson(response.data);
  }
}