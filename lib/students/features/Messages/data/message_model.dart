class ConversationModel {
  final String partnerId;
  final String partnerName;
  final String lastMessage;
  final String sentAt;
  final int unreadCount;

  ConversationModel({
    required this.partnerId,
    required this.partnerName,
    required this.lastMessage,
    required this.sentAt,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      partnerId: json['partnerId'] as String? ?? '',
      partnerName: json['partnerName'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      sentAt: json['sentAt'] as String? ?? '',
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}

class ChatMessageModel {
  final int id;
  final String content;
  final String sentAt;
  final bool isMine;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.isMine,
    required this.isRead,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      sentAt: json['sentAt'] as String? ?? '',
      isMine: json['isMine'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}