import 'package:flutter/material.dart';
import 'checkbox/teacher_option.dart';
import 'checkbox/teacher_checkbox_tile.dart';
import 'checkbox/teachers_checkbox_container.dart';

export 'checkbox/teacher_option.dart';

class TeachersCheckboxList extends StatelessWidget {
  final List<TeacherOption> teachers;
  final List<bool> selected;
  final void Function(int) onToggle;

  const TeachersCheckboxList({super.key, required this.teachers, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _ListLabel(),
      const SizedBox(height: 8),
      TeachersCheckboxContainer(teachers: teachers, selected: selected, onToggle: onToggle),
    ]);
  }
}

class _ListLabel extends StatelessWidget {
  const _ListLabel();
  @override
  Widget build(BuildContext context) {
    return const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Assign Teachers', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
      SizedBox(height: 4),
      Text('Select teachers this moderator will be responsible for.', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF94A3B8))),
    ]);
  }
}
