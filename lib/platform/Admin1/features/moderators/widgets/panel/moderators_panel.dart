import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/panel_header.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/checkbox/teacher_option.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/cubit/moderators_cubit.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/data/moderator_model.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/widgets/panel/moderator_controllers.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/widgets/panel/moderator_panel_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ModeratorPanel extends StatefulWidget {
  final ModeratorModel? moderator;
  final List<TeacherOption> teachers;
  final VoidCallback onClose;

  const ModeratorPanel({
    super.key,
    this.moderator,
    required this.teachers,
    required this.onClose,
  });

  @override
  State<ModeratorPanel> createState() => _ModeratorPanelState();
}

class _ModeratorPanelState extends State<ModeratorPanel> {
  final _formKey = GlobalKey<FormState>();
  final _ctrls   = ModeratorControllers();
  late List<bool> _selected;
  bool _obscurePass = true, _obscureConf = true;

  bool get _isEdit => widget.moderator != null;

  @override
  void initState() {
    super.initState();
    _ctrls.init(widget.moderator);
    _selected = widget.teachers.map((t) =>
      widget.moderator?.assignedTeacherIds.contains(t.id) ?? false
    ).toList();
  }

  @override
  void dispose() { _ctrls.dispose(); super.dispose(); }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ModeratorsCubit>();

    final nameParts = _ctrls.name.text.trim().split(' ');
    final firstname = nameParts.first;
    final lastname  = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final assignedIds = <String>[
      for (int i = 0; i < widget.teachers.length; i++)
        if (_selected[i]) widget.teachers[i].id,
    ];

    if (_isEdit) {
      cubit.updateModerator(
        id: widget.moderator!.id,
        firstname: firstname,
        lastname: lastname,
        assignedTeacherIds: assignedIds,
      );
    } else {
      cubit.addModerator(
        firstname: firstname,
        lastname: lastname,
        email: _ctrls.email.text,
        password: _ctrls.pass.text,
        assignedTeacherIds: assignedIds,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: panelWidth(context), height: double.infinity, color: Colors.white,
      child: Column(children: [
        PanelHeader(
          title: _isEdit ? 'Edit Moderator' : 'Add Moderator',
          onClose: widget.onClose,
        ),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: BlocBuilder<ModeratorsCubit, ModeratorsState>(
              builder: (context, state) {
                final isLoading = state is ModeratorsLoaded && state.isSubmitting;
                return ModeratorPanelForm(
                  nameCtrl:  _ctrls.name,
                  emailCtrl: _ctrls.email,
                  passCtrl:  _ctrls.pass,
                  confCtrl:  _ctrls.conf,
                  teachers:  widget.teachers,
                  selected:  _selected,
                  obscurePass: _obscurePass,
                  obscureConf: _obscureConf,
                  isEdit:    _isEdit,
                  isLoading: isLoading,
                  onToggleTeacher: (i) => setState(() => _selected[i] = !_selected[i]),
                  onTogglePass: () => setState(() => _obscurePass = !_obscurePass),
                  onToggleConf: () => setState(() => _obscureConf = !_obscureConf),
                  onSubmit:  _submit,
                );
              },
            ),
          ),
        )),
      ]),
    );
  }
}