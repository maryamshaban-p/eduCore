import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'teacher_option.dart';
import 'teacher_checkbox_tile.dart';

class TeachersCheckboxContainer extends StatelessWidget {
  final List<TeacherOption> teachers;
  final List<bool> selected;
  final void Function(int) onToggle;
  const TeachersCheckboxContainer({super.key, required this.teachers, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.slate200), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: List.generate(teachers.length, (i) => Column(children: [
              TeacherCheckboxTile(teacher: teachers[i], checked: selected[i], onTap: () => onToggle(i)),
              if (i < teachers.length - 1) const Divider(height: 1, color: AppColors.slate200),
            ])),
      ),
    );
  }
}
