import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final bool collapsed;
  final double fadeValue;
  final VoidCallback onTap;
  const LogoutButton({super.key, required this.collapsed, required this.fadeValue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white.withValues(alpha: 0.05)),
        child: Row(
          mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            const Icon(Icons.logout_rounded, size: 18, color: Colors.white54),
            if (fadeValue > 0) ...[
              const SizedBox(width: 8),
              Opacity(opacity: fadeValue, child: const Text('Logout', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white54))),
            ],
          ],
        ),
      ),
    );
  }
}
