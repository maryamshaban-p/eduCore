import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.school_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Text('EduCore',
              style: TextStyle(fontFamily: 'Inter', fontSize: 34,
                  fontWeight: FontWeight.w600, color: Colors.white)),
        ]),
        const SizedBox(height: 6),
        Text('Educational Platform Management System',
            style: TextStyle(fontFamily: 'Inter', fontSize: 14,
                color: Colors.white.withValues(alpha: 0.6))),
      ],
    );
  }
}
