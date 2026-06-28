import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/table/table_widgets.dart';
import 'package:flutter/material.dart';
import '../../data/teacher_model.dart';
import 'teachers_table_header.dart';
import 'teachers_table_row.dart';

class TeachersTable extends StatelessWidget {
  final List<TeacherModel> teachers;
  final void Function(TeacherModel) onEdit;
  const TeachersTable({super.key, required this.teachers, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return TableContainer(
      child: Column(children: [
        const TeachersTableHeader(),
        const Divider(height: 1, color: AppColors.slate200),
        ...teachers.asMap().entries.map((e) => Column(children: [
              TeachersTableRow(teacher: e.value, onEdit: onEdit),
              if (e.key < teachers.length - 1)
                const Divider(height: 1, color: AppColors.slate200),
            ])),
      ]),
    );
  }
}
