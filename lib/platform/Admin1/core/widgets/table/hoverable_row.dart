import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class HoverableRow extends StatefulWidget {
  final Widget child;
  const HoverableRow({super.key, required this.child});
  @override
  State<HoverableRow> createState() => _HoverableRowState();
}

class _HoverableRowState extends State<HoverableRow> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _hovered ? AppColors.slate50 : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: widget.child,
      ),
    );
  }
}
