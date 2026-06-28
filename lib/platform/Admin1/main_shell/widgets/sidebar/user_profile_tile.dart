import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class UserProfileTile extends StatelessWidget {
  final double fadeValue;
  const UserProfileTile({super.key, required this.fadeValue});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: fadeValue,
      child: Row(children: [
        CircleAvatar(radius: 18, backgroundColor: AppColors.primary,
            child: const Text('AF', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Ahmed Fouad', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          Text('Admin', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
        ])),
      ]),
    );
  }
}
