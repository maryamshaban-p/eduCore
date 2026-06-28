import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

InputDecoration panelInputDeco(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.slate400),
  filled: true, fillColor: AppColors.slate50, isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  border:             OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.slate200)),
  enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.slate200)),
  focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
  errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.danger)),
  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.danger, width: 2)),
);
