import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      IconButton(icon: const Icon(Icons.notifications_none_rounded, color: AppColors.slate600, size: 22), onPressed: () {}),
      Positioned(right: 8, top: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))),
    ]);
  }
}
