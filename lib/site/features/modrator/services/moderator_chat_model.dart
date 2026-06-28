/// A single message inside a moderator↔student conversation, as returned
/// by GET /api/moderator/messages/{studentId} and POST (same shape).
class ModeratorChatMessage {
  final int id;
  final String senderId;
  final String senderName;
  final bool isFromModerator;
  final String content;
  final DateTime sentAt;
  final String timeAgo;
  final bool isRead;

  ModeratorChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.isFromModerator,
    required this.content,
    required this.sentAt,
    required this.timeAgo,
    required this.isRead,
  });

  factory ModeratorChatMessage.fromJson(Map<String, dynamic> json) {
    return ModeratorChatMessage(
      id: json['id'] ?? 0,
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      isFromModerator: json['isFromModerator'] ?? false,
      content: json['content'] ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
      timeAgo: json['timeAgo'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }
}

/// One entry in the moderator's contacts list, as returned by
/// GET /api/moderator/messages/contacts.
///
/// `studentId` here is the value to pass into getConversation/sendMessage —
/// confirmed against the live API to be the student's `userId` (the Users
/// table id), not the separate Students-table id.
class ModeratorContact {
  final String studentId;
  final String fullName;
  final String avatarInitials;
  final String lastMessage;
  final DateTime lastMessageAt;
  final String timeAgo;
  final int unreadCount;

  ModeratorContact({
    required this.studentId,
    required this.fullName,
    required this.avatarInitials,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.timeAgo,
    required this.unreadCount,
  });

  factory ModeratorContact.fromJson(Map<String, dynamic> json) {
    return ModeratorContact(
      studentId: json['studentId'] ?? '',
      fullName: json['fullName'] ?? '',
      avatarInitials: json['avatarInitials'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageAt: DateTime.tryParse(json['lastMessageAt'] ?? '') ?? DateTime.now(),
      timeAgo: json['timeAgo'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}

/// Minimal response returned by POST /api/moderator/messages/{studentId}.
/// The API actually returns the full message shape (same as
/// ModeratorChatMessage) on this endpoint, so reuse that model directly —
/// no separate "send result" type needed on the moderator side.