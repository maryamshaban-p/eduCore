import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:edulink_app/core/services/student_notification_service.dart';
import 'package:edulink_app/core/services/student_notification_hub_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // ── Services ──────────────────────────────────────────────────────────────
  final StudentNotificationService _service = StudentNotificationService();

  StudentNotificationHubService? _hub;
  StreamSubscription<StudentNotification>? _hubSub;

  // ── State ─────────────────────────────────────────────────────────────────
  bool isLoading = true;
  List<StudentNotification> notifications = [];

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    loadNotifications();
    _initHub();
  }

  @override
  void dispose() {
    _hubSub?.cancel();
    _hub?.dispose();
    super.dispose();
  }

  // ── SignalR ───────────────────────────────────────────────────────────────

  Future<void> _initHub() async {
    // Uses the same token as ApiService — swap to StorageService when auth is wired up
    final token = await StorageService().getToken();
    if (token == null || !mounted) return;
    _hub = StudentNotificationHubService(token: token);

    try {
      await _hub!.connect();
      _hubSub = _hub!.onNotification.listen((incoming) {
        if (!mounted) return;
        setState(() => notifications.insert(0, incoming));
        _showSnackBar(incoming);
      });
    } catch (_) {
      // Hub unreachable — REST still works
    }
  }

  void _showSnackBar(StudentNotification notification) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 4),
        backgroundColor: Theme.of(context).primaryColor,
        content: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              child: Icon(getIcon(notification.type),
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    notification.message,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── REST ──────────────────────────────────────────────────────────────────

  Future<void> loadNotifications() async {
    try {
      final result = await _service.getNotifications();
      setState(() {
        notifications = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> markAsRead(StudentNotification notification) async {
    if (notification.isRead) return;
    await _service.markAsRead(notification.id);
    setState(() {
      final index =
          notifications.indexWhere((e) => e.id == notification.id);
      notifications[index] = notification.copyAsRead();
    });
  }

  Future<void> markAllRead() async {
    await _service.markAllAsRead();
    setState(() {
      notifications = notifications.map((e) => e.copyAsRead()).toList();
    });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  IconData getIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'course':
      case 'new_content':
        return Icons.play_circle_fill_rounded;
      case 'exam':
        return Icons.assignment_rounded;
      case 'payment':
        return Icons.payments_rounded;
      case 'low_views':
        return Icons.visibility_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: markAllRead,
            icon: const Icon(Icons.done_all_rounded),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: MediaQuery.of(context).size.height * 0.1,
                        color: Colors.grey,
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.02),
                      Text(
                        'No Notifications Yet'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadNotifications,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width * 0.04,
                      vertical:
                          MediaQuery.of(context).size.height * 0.02,
                    ),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];

                      return Dismissible(
                        key: Key(notification.id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) async {
                          await _service.deleteNotification(notification.id);
                          setState(() => notifications.removeAt(index));
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.06,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: GestureDetector(
                          onTap: () => markAsRead(notification),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height *
                                  0.015,
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.04),
                            decoration: BoxDecoration(
                              color: notification.isRead
                                  ? Theme.of(context).cardColor
                                  : primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: notification.isRead
                                    ? Colors.transparent
                                    : primary,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: MediaQuery.of(context).size.width *
                                      0.06,
                                  child: Icon(getIcon(notification.type)),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.006),
                                      Text(notification.message),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.008),
                                      Text(
                                        notification.timeAgo,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!notification.isRead)
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.025,
                                    height:
                                        MediaQuery.of(context).size.width *
                                            0.025,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}