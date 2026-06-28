import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/landing_page/views/landing.dart';
import 'package:edulink_app/site/shared_widgets/custom_dashboard_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomPersoninfoItem extends StatelessWidget {
  CustomPersoninfoItem({
    super.key,
    required this.screenWidth,
    required this.name,
    required this.discription,
    required this.intials,
    this.color,
    this.style,
    this.isCollapsed = false, // ← بتيجي من برة دلوقتي، مش بتحسبها لوحدها
  });

  final double screenWidth;
  final String name;
  final String discription;
  final String intials;
  final bool isCollapsed;

  Color? color;
  TextStyle? style;

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.slate800,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.slate600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.slate600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LandingPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: color ?? AppColors.primaryDark,
            ),
            child: Center(
              child: Text(
                intials,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Custom_Dashboard_item(
            screenWidth: screenWidth,
            icon: Icons.logout_outlined,
            labelName: 'Logout',
            isActive: false,
            onTap: () => _showLogoutDialog(context),
            isCollapsed: true,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                color: color ?? AppColors.primaryDark,
              ),
              child: Center(
                child: Text(
                  intials,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: style ??
                        const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    discription,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.slate400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Custom_Dashboard_item(
          screenWidth: screenWidth,
          icon: Icons.logout_outlined,
          labelName: 'Logout',
          isActive: false,
          onTap: () => _showLogoutDialog(context),
          isCollapsed: false,
        ),
      ],
    );
  }
}