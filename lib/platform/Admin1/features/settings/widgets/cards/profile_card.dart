import 'package:flutter/material.dart';
import 'settings_card.dart';
import 'settings_form_field.dart';
import 'save_changes_button.dart';

class ProfileCard extends StatelessWidget {
  final TextEditingController nameCtrl, emailCtrl, addressCtrl, phoneCtrl;
  final VoidCallback onSave;
  final bool isLoading;

  const ProfileCard({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.addressCtrl,
    required this.phoneCtrl,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Institution Profile',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SettingsFieldRow(
          left:  SettingsTextField(label: 'Institution Name', ctrl: nameCtrl,  hint: 'Al-Nour Educational Center'),
          right: SettingsTextField(label: 'Contact Email',    ctrl: emailCtrl, hint: 'info@alnour.edu', keyboardType: TextInputType.emailAddress),
        ),
        const SizedBox(height: 16),
        SettingsFieldRow(
          left:  SettingsTextField(label: 'Address', ctrl: addressCtrl, hint: '15 Tahrir Street, Cairo'),
          right: SettingsTextField(label: 'Phone',   ctrl: phoneCtrl,   hint: '+20 2 1234 5678', keyboardType: TextInputType.phone),
        ),
        const SizedBox(height: 24),
        SaveChangesButton(onSave: onSave, isLoading: isLoading),
      ]),
    );
  }
}