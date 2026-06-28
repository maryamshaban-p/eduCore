import 'package:flutter/material.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/form/panel_form_field.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/form/panel_password_field.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/form/panel_submit_button.dart';

class TeacherPanelForm extends StatelessWidget {
  final TextEditingController nameCtrl, emailCtrl, subjectCtrl, passCtrl, confCtrl;
  final bool obscurePass, obscureConf, isEdit, isLoading;
  final VoidCallback onTogglePass, onToggleConf, onSubmit;

  const TeacherPanelForm({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.subjectCtrl,
    required this.passCtrl,
    required this.confCtrl,
    required this.obscurePass,
    required this.obscureConf,
    required this.isEdit,
    this.isLoading = false,
    required this.onTogglePass,
    required this.onToggleConf,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PanelFormField(label: 'Full Name', ctrl: nameCtrl, hint: 'Dr. Ahmed Hassan'),
      const SizedBox(height: 16),
      PanelFormField(label: 'Email', ctrl: emailCtrl, hint: 'ahmed@alnour.edu', keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 16),
      PanelFormField(label: 'Subject', ctrl: subjectCtrl, hint: 'Mathematics'),
      if (!isEdit) ...[
        const SizedBox(height: 16),
        PanelPasswordField(label: 'Password', ctrl: passCtrl, obscure: obscurePass, onToggle: onTogglePass),
        const SizedBox(height: 16),
        PanelPasswordField(label: 'Confirm Password', ctrl: confCtrl, obscure: obscureConf, onToggle: onToggleConf, confirmCtrl: passCtrl),
      ],
      const SizedBox(height: 32),
      PanelSubmitButton(isEdit: isEdit, isLoading: isLoading, onPressed: onSubmit),
    ]);
  }
}