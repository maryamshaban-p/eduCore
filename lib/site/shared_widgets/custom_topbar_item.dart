import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class CustomTopbarItem extends StatelessWidget implements PreferredSizeWidget {
  const CustomTopbarItem({
    super.key,
    required this.pageName,
    required this.userName,
    required this.userInitials,
    this.showMenuButton = false, // mobile: opens Drawer
  });

  final String pageName;
  final String userName;
  final String userInitials;
  final bool showMenuButton;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── الزرار ده هيظهر بس لما الشاشة تكون صغيرة (موبايل) ──
          if (showMenuButton) ...[
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: AppColors.slate700),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(width: 10),
          ],

          Text(
            pageName,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),

          const Spacer(),

          // Notification bell
         /* Stack(clipBehavior: Clip.none, children: [
            const Icon(Icons.notifications_none_rounded,
                color: AppColors.slate600, size: 22),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.info, shape: BoxShape.circle),
              ),
            ),
          ]),*/

          const SizedBox(width: 14),

          // User avatar + name
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(userInitials,
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            Text(userName,
                style: const TextStyle(
                  //  fontFamily: 'Inter',
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate800)),
          ]),
        ],
      ),
    );
  }
}