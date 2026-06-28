import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.prefix,
    this.suffix,
    this.hintText,
    this.controller,
    this.obscureText = false,
  });

  final Widget? prefix;
  final Widget? suffix;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 19, horizontal: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hintText: hintText,
        hintStyle: AppStyles.charcoalGray,
        prefixIcon: prefix,
        prefixStyle: AppStyles.coalGray,
        suffixIcon: suffix,
        suffixStyle: AppStyles.lightGray16,
        fillColor: AppColors.whiteColor,
        filled: true,
      ),
    );
  }
}