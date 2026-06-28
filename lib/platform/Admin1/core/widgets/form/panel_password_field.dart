import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'field_label.dart';
import 'panel_input_deco.dart';

class PanelPasswordField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool obscure;
  final VoidCallback onToggle;
  final TextEditingController? confirmCtrl;

  const PanelPasswordField({super.key, required this.label, required this.ctrl, required this.obscure, required this.onToggle, this.confirmCtrl});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      FieldLabel(label),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl, obscureText: obscure,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
        decoration: panelInputDeco('••••••••').copyWith(
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.slate400, size: 20),
            onPressed: onToggle,
          ),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return '$label is required';
          if (v.length < 6) return 'At least 6 characters';
          if (confirmCtrl != null && v != confirmCtrl!.text) return 'Passwords do not match';
          return null;
        },
      ),
    ]);
  }
}
