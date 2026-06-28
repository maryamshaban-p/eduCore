/// A single message inside a student's conversation with a moderator/
/// teacher, as returned by GET /api/student/messages/{partnerId}.
///
/// Note this shape is intentionally simpler than the moderator side's
/// ModeratorChatMessage — it has no senderId/senderName, just `isMine`
/// to tell which side sent it.
class StudentChatMessage {
  final int id;
  final String content;
  final DateTime sentAt;
  final bool isMine;
  final bool isRead;

  StudentChatMessage({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.isMine,
    required this.isRead,
  });

  factory StudentChatMessage.fromJson(Map<String, dynamic> json) {
    return StudentChatMessage(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
      isMine: json['isMine'] ?? false,
      isRead: json['isRead'] ?? false,
    );
  }
}

/// One entry in the student's conversations list, as returned by
/// GET /api/student/messages.
class StudentConversation {
  final String partnerId;
  final String partnerName;
  final String lastMessage;
  final DateTime sentAt;
  final int unreadCount;

  StudentConversation({
    required this.partnerId,
    required this.partnerName,
    required this.lastMessage,
    required this.sentAt,
    required this.unreadCount,
  });

  factory StudentConversation.fromJson(Map<String, dynamic> json) {
    return StudentConversation(
      partnerId: json['partnerId'] ?? '',
      partnerName: json['partnerName'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}

/// Returned by POST /api/student/messages/{receiverId}.
///
/// Deliberately minimal — the API only echoes back {id, sentAt}, not the
/// content. Callers should keep the content they just sent locally (e.g.
/// via an optimistic UI message) rather than expecting it back here.
class SendMessageResult {
  final int id;
  final DateTime sentAt;

  SendMessageResult({required this.id, required this.sentAt});

  factory SendMessageResult.fromJson(Map<String, dynamic> json) {
    return SendMessageResult(
      id: json['id'] ?? 0,
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
    );
  }
}