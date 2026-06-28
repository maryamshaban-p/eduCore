import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'appbar/appbar_user_info.dart';
import 'appbar/notification_bell.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const DashboardAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.slate200))),
      child: Row(children: [
        if (Breakpoints.isMobile(context)) ...[
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.slate600),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(title, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 18,
                  fontWeight: FontWeight.w600, color: AppColors.slate900)),
        ),
        const NotificationBell(),
        const SizedBox(width: 8),
        const AppBarUserInfo(),
      ]),
    );
  }
}
