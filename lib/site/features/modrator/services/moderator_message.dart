import '../../../../core/services/api_service.dart';

import 'package:edulink_app/site/features/modrator/services/moderator_chat_model.dart';

class ModeratorMessageService {
  final ApiService _api = ApiService();

  /// GET /api/moderator/messages/contacts
  Future<List<ModeratorContact>> getContacts() async {
    final response = await _api.get('/moderator/messages/contacts');
    return (response.data as List)
        .map((item) => ModeratorContact.fromJson(item))
        .toList();
  }

  /// GET /api/moderator/messages/{studentId}
  ///
  /// [studentId] must be the student's `userId` (from the Users table) —
  /// confirmed against the live API. This is exactly the `studentId` value
  /// already returned by getContacts(), so callers don't need to do any
  /// translation themselves; just pass ModeratorContact.studentId through.
  Future<List<ModeratorChatMessage>> getConversation(String studentId) async {
    final response = await _api.get('/moderator/messages/$studentId');
    return (response.data as List)
        .map((item) => ModeratorChatMessage.fromJson(item))
        .toList();
  }

  /// POST /api/moderator/messages/{studentId}
  /// Returns the newly created message (server echoes back the full shape).
  Future<ModeratorChatMessage> sendMessage({
    required String studentId,
    required String content,
  }) async {
    final response = await _api.post('/moderator/messages/$studentId', {
      'content': content,
    });
    return ModeratorChatMessage.fromJson(response.data);
  }
}