import 'package:flutter/material.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/form/panel_form_field.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/form/panel_password_field.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/form/panel_submit_button.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/teachers_checkbox_list.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/checkbox/teacher_option.dart';

class ModeratorPanelForm extends StatelessWidget {
  final TextEditingController nameCtrl, emailCtrl, passCtrl, confCtrl;
  final List<TeacherOption> teachers;
  final List<bool> selected;
  final bool obscurePass, obscureConf, isEdit, isLoading;
  final void Function(int) onToggleTeacher;
  final VoidCallback onTogglePass, onToggleConf, onSubmit;

  const ModeratorPanelForm({
    super.key,
    required this.nameCtrl,  required this.emailCtrl,
    required this.passCtrl,  required this.confCtrl,
    required this.teachers,  required this.selected,
    required this.obscurePass, required this.obscureConf,
    required this.isEdit,
    this.isLoading = false,
    required this.onToggleTeacher,
    required this.onTogglePass,
    required this.onToggleConf,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PanelFormField(label: 'Full Name', ctrl: nameCtrl, hint: 'Nadia Mostafa'),
      const SizedBox(height: 16),
      if (!isEdit) ...[
        PanelFormField(label: 'Email', ctrl: emailCtrl, hint: 'nadia@alnour.edu', keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
      ],
      TeachersCheckboxList(teachers: teachers, selected: selected, onToggle: onToggleTeacher),
      if (!isEdit) ...[
        const SizedBox(height: 16),
        PanelPasswordField(label: 'Password', ctrl: passCtrl, obscure: obscurePass, onToggle: onTogglePass),
        const SizedBox(height: 16),
        PanelPasswordField(label: 'Confirm Password', ctrl: confCtrl, obscure: obscureConf, onToggle: onToggleConf, confirmCtrl: passCtrl),
      ],
      const SizedBox(height: 28),
      PanelSubmitButton(isEdit: isEdit, isLoading: isLoading, onPressed: onSubmit),
    ]);
  }
}