import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class LogoutDialogContent extends StatelessWidget {
  const LogoutDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      _LogoutIcon(),
      SizedBox(height: 16),
      _LogoutTitle(),
      SizedBox(height: 8),
      _LogoutSubtitle(),
    ]);
  }
}

class _LogoutIcon extends StatelessWidget {
  const _LogoutIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 26),
    );
  }
}

class _LogoutTitle extends StatelessWidget {
  const _LogoutTitle();
  @override
  Widget build(BuildContext context) {
    return const Text('Logout',
        style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.slate900));
  }
}

class _LogoutSubtitle extends StatelessWidget {
  const _LogoutSubtitle();
  @override
  Widget build(BuildContext context) {
    return const Text('Are you sure you want to logout?',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.slate500));
  }
}
