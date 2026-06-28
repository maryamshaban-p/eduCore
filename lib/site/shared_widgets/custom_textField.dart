import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class custom_textField extends StatelessWidget {
  const custom_textField({
    super.key,
    this.iconName,
    this.label,
    this.controller,
    this.hintText,
  });

  final Widget? iconName;
  final Widget? label;
  final TextEditingController? controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: AppColors.slate800,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.slate400,
          ),
          label: label,
          filled: true,
          fillColor: AppColors.slate50,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.slate200),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.slate200),
          ),
          prefixIcon: iconName,
        ),
      ),
    );
  }
}
