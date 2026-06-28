import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/table/table_widgets.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/data/moderator_model.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/widgets/table/moderators_table_header.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/widgets/table/moderators_table_row.dart';
import 'package:flutter/material.dart';


class ModeratorsTable extends StatelessWidget {
  final List<ModeratorModel> moderators;
  final void Function(ModeratorModel) onEdit;

  const ModeratorsTable({super.key, required this.moderators, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return TableContainer(
      child: Column(children: [
        const ModeratorsTableHeader(),
        const Divider(height: 1, color: AppColors.slate200),
        ...moderators.asMap().entries.map((e) => Column(children: [
          ModeratorsTableRow(moderator: e.value, onEdit: onEdit),
          if (e.key < moderators.length - 1)
            const Divider(height: 1, color: AppColors.slate200),
        ])),
      ]),
    );
  }
}