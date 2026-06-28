import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'navbar/mobile_menu.dart';
import 'navbar/nav_link.dart';
import 'navbar/nav_logo.dart';

class NavbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onFeaturesTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onFaqTap;

  const NavbarWidget({super.key, this.onFeaturesTap, this.onAboutTap, this.onFaqTap});

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.slate200,
      toolbarHeight: 76,
      leading: const NavLogo(),
      leadingWidth: 68,
      title: const Text('EduCore',
          style: TextStyle(fontFamily: 'Inter', fontSize: 22,
              fontWeight: FontWeight.w600, color: AppColors.slate900)),
      actions: isMobile
          ? [MobileMenuButton(onFeaturesTap: onFeaturesTap, onAboutTap: onAboutTap, onFaqTap: onFaqTap)]
          : [
              NavLink(label: 'Features',   onTap: onFeaturesTap ?? () {}),
              NavLink(label: 'About',      onTap: onAboutTap    ?? () {}),
              NavLink(label: 'Contact Us', onTap: onFaqTap      ?? () {}),
              const SizedBox(width: 24),
            ],
    );
  }
}
