import 'package:edulink_app/platform/Admin1/core/widgets/table/table_header_cell.dart';
import 'package:flutter/material.dart';

class TeachersTableHeader extends StatelessWidget {
  const TeachersTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        Expanded(flex: 4, child: TableHeaderCell('Name')),
        Expanded(flex: 3, child: TableHeaderCell('Subject')),
        Expanded(flex: 2, child: TableHeaderCell('Students')),
        Expanded(flex: 2, child: TableHeaderCell('Courses')),
        SizedBox(width: 80, child: TableHeaderCell('Actions')),
      ]),
    );
  }
}