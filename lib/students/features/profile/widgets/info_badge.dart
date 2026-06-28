import 'package:flutter/material.dart';

class InfoBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const InfoBadge({
    super.key,
    required this.label,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.015,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}