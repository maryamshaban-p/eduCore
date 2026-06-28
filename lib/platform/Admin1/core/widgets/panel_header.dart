import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

/// هيدر مشترك لكل الـ slide panels
class PanelHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  const PanelHeader({super.key, required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.slate200))),
      child: Row(children: [
        Text(title,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.slate900)),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.slate500, size: 22),
          onPressed: onClose,
        ),
      ]),
    );
  }
}
