import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/action_btn.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/table/table_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/moderators_cubit.dart';
import '../../data/moderator_model.dart';

class ModeratorsTableRow extends StatelessWidget {
  final ModeratorModel moderator;
  final void Function(ModeratorModel) onEdit;

  const ModeratorsTableRow({super.key, required this.moderator, required this.onEdit});

  String get _initials => moderator.name
    .split(' ')
    .where((w) => w.isNotEmpty)
    .take(2)
    .map((w) => w[0].toUpperCase())
    .join();

  @override
  Widget build(BuildContext context) {
    return HoverableRow(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: NameWithAvatar(name: moderator.name, initials: _initials)),
          Expanded(flex: 3, child: _Cell('${moderator.assignedTeacherIds.length} teachers')),
          Expanded(flex: 2, child: _Cell('${moderator.studentsManaged}')),
          Expanded(flex: 2, child: _Cell(moderator.lastActive, color: AppColors.slate400)),
          SizedBox(width: 80, child: Row(children: [
            ActionBtn(icon: Icons.edit_outlined, onTap: () => onEdit(moderator)),
            const SizedBox(width: 8),
            ActionBtn(icon: Icons.delete_outlined, onTap: () => _confirmDelete(context)),
          ])),
        ]),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<ModeratorsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Moderator'),
        content: Text('Are you sure you want to delete ${moderator.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteModerator(moderator.id);
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