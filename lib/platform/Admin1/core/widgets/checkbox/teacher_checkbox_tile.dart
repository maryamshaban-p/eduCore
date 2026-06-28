import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'teacher_option.dart';

class TeacherCheckboxTile extends StatelessWidget {
  final TeacherOption teacher;
  final bool checked;
  final VoidCallback onTap;
  const TeacherCheckboxTile({super.key, required this.teacher, required this.checked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: checked ? AppColors.primaryXL : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: checked ? Border.all(color: AppColors.primaryLight) : null,
        ),
        child: Row(children: [
          Checkbox(value: checked, onChanged: (_) => onTap(), activeColor: AppColors.primary, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(teacher.name, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.slate800)),
            Text(teacher.subject, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
          ]),
        ]),
      ),
    );
  }
}
