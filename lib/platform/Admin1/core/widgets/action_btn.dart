import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
/// زر أيقونة مع hover effect — مشترك بين كل الـ features

class ActionBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ActionBtn({super.key, required this.icon, required this.onTap});

  @override
  State<ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<ActionBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.slate100 : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: _hovered ? AppColors.slate700 : AppColors.slate400,
          ),
        ),
      ),
    );
  }
}
