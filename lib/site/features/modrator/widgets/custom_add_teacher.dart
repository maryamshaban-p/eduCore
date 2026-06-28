import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class CustomAddTeacherWidget extends StatelessWidget {
   CustomAddTeacherWidget({
    super.key,
    required this.teacherName,
    this.subject,
    required this.intials,
    this.icon,
    this.onIconPressed,
    // kept for backwards compat — ignored
    double? screenWidth,
    double? screenHeight,
  });

  final String teacherName;
  final String? subject;
  final String intials;
  final Widget? icon;
  final VoidCallback? onIconPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.slate200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        // Avatar
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.primaryXL, borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Text(intials, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
        const SizedBox(width: 10),
        // Name + subject
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(teacherName, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate800), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
          if (subject != null && subject!.isNotEmpty)
           Text(subject!, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate500), overflow: TextOverflow.ellipsis),
          ]),
        ),
        // Action icon
        if (icon != null)
          IconButton(
            onPressed: onIconPressed,
            icon: icon!,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 18,
          ),
      ]),
    );
  }
}
