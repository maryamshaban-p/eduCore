
import 'dart:developer';

import 'package:edulink_app/core/services/api_sevice_student.dart';

class StudentNotification {
  final int id;
  final String title;
  final String timeAgo;
  final String message;
  final bool isRead;
  final DateTime? createdAt;
  final String? type;

  StudentNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    this.createdAt,
    this.type, required this.timeAgo,
  });

  factory StudentNotification.fromJson(Map<String, dynamic> json) {
    return StudentNotification(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      type: json['type'],
      timeAgo: json['timeAgo'] ?? '',
    );
  }

  /// Returns a copy with isRead flipped to true — handy for optimistic UI
  /// updates after calling markAsRead/markAllAsRead without waiting on a
  /// full re-fetch.
  StudentNotification copyAsRead() {
    return StudentNotification(
      id: id,
      title: title,
      message: message,
      isRead: true,
      createdAt: createdAt,
      type: type,
      timeAgo: timeAgo,
    );
  }
}

class StudentNotificationService {
  final ApiService _api = ApiService();

  /// GET /api/student/notifications
  /// [unreadOnly] mirrors the API's query default of false.
  Future<List<StudentNotification>> getNotifications({bool unreadOnly = false}) async {
    final response = await _api.get(
      '/student/notifications',
      queryParameters: {'unreadOnly': unreadOnly},
    );
      log('notifications raw response: ${response.data.runtimeType} => ${response.data}');

    return (response.data as List)
        .map((item) => StudentNotification.fromJson(item))
        .toList();
  }

  /// GET /api/student/notifications/unread-count
  /// Assumes the response is either a bare integer or an object containing
  /// a `count` field — handles both shapes defensively.
  Future<int> getUnreadCount() async {
    final response = await _api.get('/student/notifications/unread-count');
    final data = response.data;
    if (data is int) return data;
    if (data is Map<String, dynamic>) {
      return data['count'] ?? data['unreadCount'] ?? 0;
    }
    return 0;
  }

  /// PATCH /api/student/notifications/{id}/read
  Future<void> markAsRead(int id) async {
    await _api.patch('/student/notifications/$id/read', {});
  }

  /// PATCH /api/student/notifications/read-all
  Future<void> markAllAsRead() async {
    await _api.patch('/student/notifications/read-all', {});
  }

  /// DELETE /api/student/notifications/{id}
  Future<void> deleteNotification(int id) async {
    await _api.delete('/student/notifications/$id');
  }
}