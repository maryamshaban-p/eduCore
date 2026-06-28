import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class LoginLabel extends StatelessWidget {
  final String text;
  const LoginLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          fontFamily: 'Inter', fontSize: 14,
          fontWeight: FontWeight.w600, color: AppColors.slate800,
        ));
  }
}

InputDecoration loginInputDeco({required String hint, Widget? suffix}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
        fontFamily: 'Inter', fontSize: 14, color: AppColors.slate500),
    suffixIcon: suffix,
    filled: true, fillColor: AppColors.slate50, isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border:             OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.slate200)),
    enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.slate200)),
    focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
    errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.danger)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.danger, width: 2)),
  );
}
