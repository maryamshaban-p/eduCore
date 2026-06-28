import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:edulink_app/core/services/student_notification_service.dart';

/// Manages the SignalR connection to /hubs/notifications.
class StudentNotificationHubService {
  // ── Configuration ─────────────────────────────────────────────────────────
  // TODO: move to your AppConfig / environment file
  static const String _baseUrl = 'http://localhost:5132'; 
  static const String _hubPath = '/hubs/notifications';
  static const String _clientMethod = 'ReceiveNotification';

  // ── State ─────────────────────────────────────────────────────────────────
  final String token;
  HubConnection? _connection;

  final _controller = StreamController<StudentNotification>.broadcast();

  Stream<StudentNotification> get onNotification => _controller.stream;

  bool get isConnected =>
      _connection?.state == HubConnectionState.Connected;

  StudentNotificationHubService({required this.token});

  // ── Public API ────────────────────────────────────────────────────────────

  Future<void> connect() async {
    if (isConnected) return;

    _connection = HubConnectionBuilder()
        .withUrl(
          '$_baseUrl$_hubPath',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .withAutomaticReconnect(retryDelays: [0, 2000, 10000, 30000])
        .build();

    _connection!.on(_clientMethod, (args) {
      if (args == null || args.isEmpty) return;
      final raw = args[0];
      if (raw is! Map<String, dynamic>) return;

      final notification = _fromPayload(raw);
      if (!_controller.isClosed) _controller.add(notification);
    });

    await _connection!.start();
  }

  Future<void> dispose() async {
    await _connection?.stop();
    await _controller.close();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  /// Maps the SignalR payload to [StudentNotification].
  /// Field names match StudentNotification.fromJson exactly:
  ///   id, title, body (→ message), isRead, createdAt, type, timeAgo
  StudentNotification _fromPayload(Map<String, dynamic> map) {
    return StudentNotification.fromJson({
      'id':        map['id'] ?? 0,
      'title':     map['title'] ?? '',
      'body':      map['body'] ?? '',       // backend field name
      'isRead':    false,                   // real-time = always unread
      'createdAt': map['createdAt'],
      'type':      map['type'],
      'timeAgo':   map['timeAgo'] ?? 'Just now',
    });
  }
}