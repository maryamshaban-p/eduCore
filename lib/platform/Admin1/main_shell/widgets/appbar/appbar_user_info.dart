import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class AppBarUserInfo extends StatelessWidget {
  const AppBarUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.slateDark800,
        child: const Text('AF',
            style: TextStyle(fontFamily: 'Inter', fontSize: 12,
                fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      // إخفاء الاسم على الموبايل
      if (!Breakpoints.isMobile(context)) ...[
        const SizedBox(width: 8),
        const Text('Ahmed Fouad',
            style: TextStyle(fontFamily: 'Inter', fontSize: 14,
                fontWeight: FontWeight.w500, color: AppColors.slate800)),
      ],
    ]);
  }
}
