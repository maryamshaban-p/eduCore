import 'package:edulink_app/platform/Admin1/core/widgets/table/table_widgets.dart';
import 'package:flutter/material.dart';

class ModeratorsTableHeader extends StatelessWidget {
  const ModeratorsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        Expanded(flex: 3, child: TableHeaderCell('Name')),
        Expanded(flex: 3, child: TableHeaderCell('Assigned Teachers')),
        Expanded(flex: 2, child: TableHeaderCell('Students')),
        Expanded(flex: 2, child: TableHeaderCell('Last Active')),
        SizedBox(width: 80, child: TableHeaderCell('Actions')),
      ]),
    );
  }
}