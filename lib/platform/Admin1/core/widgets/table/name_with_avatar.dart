import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class NameWithAvatar extends StatelessWidget {
  final String name;
  final String initials;
  const NameWithAvatar({super.key, required this.name, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.slate200,
        child: Text(initials,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 11,
                fontWeight: FontWeight.w600, color: AppColors.slate600)),
      ),
      const SizedBox(width: 10),
      Flexible(
        child: Text(name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 14,
                fontWeight: FontWeight.w500, color: AppColors.slate800)),
      ),
    ]);
  }
}
