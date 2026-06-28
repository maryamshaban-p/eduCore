import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const NavLink({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.slate600,
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500),
      ),
      child: Text(label),
    );
  }
}
