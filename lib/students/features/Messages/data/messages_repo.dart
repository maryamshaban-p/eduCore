import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'message_model.dart';

class MessagesRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/student';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

 Future<List<ConversationModel>> getConversations() async {
  final headers = await _headers();
  print(' Headers: $headers');

  final response = await http.get(
    Uri.parse('$_baseUrl/messages'),
    headers: headers,
  );

  print(' Status Code: ${response.statusCode}');
  print(' Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => ConversationModel.fromJson(e)).toList();
  } else if (response.statusCode == 401) {
    throw Exception('Unauthorized. Please login again.'.tr());
  } else {
    throw Exception('Failed to load conversations.'.tr());
  }
}

  Future<List<ChatMessageModel>> getChatHistory(String partnerId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/messages/$partnerId'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ChatMessageModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    } else {
      throw Exception('Failed to load messages.'.tr());
    }
  }

  Future<ChatMessageModel> sendMessage(String receiverId, String content) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/messages/$receiverId'),
      headers: await _headers(),
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ChatMessageModel(
        id: data['id'] as int? ?? 0,
        content: content,
        sentAt: data['sentAt'] as String? ?? DateTime.now().toIso8601String(),
        isMine: true,
        isRead: false,
      );
    } else {
      throw Exception('Failed to send message.'.tr());
    }
  }

  /// Returns how many messages from the moderator are still unread.
  /// Used for the badge on the Messages tab.
  Future<int> getUnreadCount() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/messages/unread-count'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['unreadCount'] as int? ?? 0;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    } else {
      throw Exception('Failed to load unread count.'.tr());
    }
  }
}
