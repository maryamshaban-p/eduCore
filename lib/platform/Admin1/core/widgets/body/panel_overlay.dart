import 'package:flutter/material.dart';

class PanelOverlay extends StatelessWidget {
  final VoidCallback onTap;
  const PanelOverlay({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(color: Colors.black.withValues(alpha: 0.18)),
    );
  }
}
