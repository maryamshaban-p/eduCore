/// Represents a single chat message, used by both the student and
/// moderator messaging services since the conversation shape is the same
/// on both sides — only the endpoint path differs (partnerId vs studentId).
///
/// Field names assume the conventional shape (id, content, senderId,
/// createdAt, isRead) since the exact API response schema wasn't
/// available when this was written. If the real response differs, only
/// fromJson needs to change.
class ChatMessage {
  final int id;
  final String content;
  final String? senderId;
  final DateTime? createdAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.content,
    this.senderId,
    this.createdAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      senderId: json['senderId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      isRead: json['isRead'] ?? false,
    );
  }

  /// Builds the local, optimistic copy of a message right after sending it
  /// — before the server's actual response (with its real id/createdAt)
  /// comes back. Useful for showing the message in the UI immediately.
  factory ChatMessage.optimistic(String content, {String? senderId}) {
    return ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch, // temporary negative id
      content: content,
      senderId: senderId,
      createdAt: DateTime.now(),
      isRead: false,
    );
  }
}