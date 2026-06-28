import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class SettingsFieldRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const SettingsFieldRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return Row(children: [
          Expanded(child: left),
          const SizedBox(width: 20),
          Expanded(child: right),
        ]);
      }
      return Column(children: [left, const SizedBox(height: 16), right]);
    });
  }
}

class SettingsTextField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  final TextInputType? keyboardType;

  const SettingsTextField({
    super.key,
    required this.label,
    required this.ctrl,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate700)),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.slate800),
        decoration: _inputDeco(hint),
      ),
    ]);
  }
}

InputDecoration _inputDeco(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.slate400),
  filled: true, fillColor: Colors.white, isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.slate200)),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.slate200)),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
);
