import 'package:flutter/material.dart';
import 'field_label.dart';
import 'panel_input_deco.dart';

class PanelFormField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  final TextInputType? keyboardType;

  const PanelFormField({super.key, required this.label, required this.ctrl, required this.hint, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      FieldLabel(label),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl, keyboardType: keyboardType,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
        decoration: panelInputDeco(hint),
        validator: (v) => (v == null || v.isEmpty) ? '$label is required' : null,
      ),
    ]);
  }
}
