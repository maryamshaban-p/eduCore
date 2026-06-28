import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/core/services/student_notification_service.dart';
import 'package:edulink_app/core/services/student_notification_hub_service.dart';
import 'package:edulink_app/core/theme/cubit/theme_cubit.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:edulink_app/students/features/notifications/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatefulWidget {
  final String studentName;

  const Header({
    super.key,
    required this.studentName,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final StudentNotificationService _notificationService =
      StudentNotificationService();

  StudentNotificationHubService? _hub;
  StreamSubscription<StudentNotification>? _hubSub;

  int unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
    _initHub();
  }

  @override
  void dispose() {
    _hubSub?.cancel();
    _hub?.dispose();
    super.dispose();
  }

  // ── REST ──────────────────────────────────────────────────────────────────

  Future<void> _loadUnreadCount() async {
    try {
      final count = await _notificationService.getUnreadCount();
      if (mounted) setState(() => unreadNotifications = count);
    } catch (_) {}
  }

  // ── SignalR — bump badge instantly on new notification ────────────────────

  Future<void> _initHub() async {
    final token = await StorageService().getToken();
    if (token == null || !mounted) return;

    _hub = StudentNotificationHubService(token: token);

    try {
      await _hub!.connect();
      _hubSub = _hub!.onNotification.listen((_) {
        if (!mounted) return;
        setState(() => unreadNotifications++);
      });
    } catch (_) {}
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
    // Re-fetch after returning — user may have read some
    await _loadUnreadCount();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'hi_name'.tr(namedArgs: {'name': widget.studentName}),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'lets_start_learning'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Spacer(),

        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return IconButton(
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              icon: Icon(
                themeState.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: textColor,
              ),
            );
          },
        ),

        Stack(
          children: [
            IconButton(
              onPressed: _openNotifications,
              icon: Icon(Icons.notifications, color: textColor, size: 28),
            ),
            if (unreadNotifications > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadNotifications > 99
                        ? '99+'
                        : '$unreadNotifications',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}