import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/action_btn.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/table/table_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/teachers_cubit.dart';
import '../../data/teacher_model.dart';

class TeachersTableRow extends StatelessWidget {
  final TeacherModel teacher;
  final void Function(TeacherModel) onEdit;

  const TeachersTableRow({super.key, required this.teacher, required this.onEdit});

  String get _initials => teacher.name
      .split(' ').where((w) => w.isNotEmpty).take(2)
      .map((w) => w[0].toUpperCase()).join();
  @override
Widget build(BuildContext context) {
  return HoverableRow(
    child: Padding(
      padding: const EdgeInsets.symmetric( vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: NameWithAvatar(name: teacher.name, initials: _initials),
          ),
          Expanded(
            flex: 3,
            child: _Cell(teacher.subject, color: AppColors.slate500),
          ),
          Expanded(
            flex: 2,
            child: _Cell('${teacher.studentsCount}'),
          ),
          Expanded(
            flex: 2,
            child: _Cell('${teacher.courseCount}'),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ActionBtn(icon: Icons.edit_outlined, onTap: () => onEdit(teacher)),
                  const SizedBox(width: 8),
                  ActionBtn(icon: Icons.delete_outlined, onTap: () => _confirmDelete(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
void _confirmDelete(BuildContext context) {
  final cubit = context.read<TeachersCubit>(); 
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Teacher'),
      content: Text('Are you sure you want to delete ${teacher.name}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            cubit.deleteTeacher(teacher.id); 
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
}

class _Cell extends StatelessWidget {
  final String text;
  final Color color;
  const _Cell(this.text, {this.color = AppColors.slate600});

  @override
  Widget build(BuildContext context) {
    return Text(text, overflow: TextOverflow.ellipsis,
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: color));
  }
}