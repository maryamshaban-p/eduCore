import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'user_profile_tile.dart';
import 'logout_button.dart';

class SidebarFooter extends StatelessWidget {
  final bool collapsed;
  final double fadeValue;
  final VoidCallback onLogout;
  const SidebarFooter({super.key, required this.collapsed, required this.fadeValue, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        if (fadeValue > 0) UserProfileTile(fadeValue: fadeValue),
        const SizedBox(height: 10),
        LogoutButton(collapsed: collapsed, fadeValue: fadeValue, onTap: onLogout),
      ]),
    );
  }
}
