import 'package:flutter/material.dart';

class QuickInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color bg;
  final Color fg;

  const QuickInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: fg,
            size: screenWidth * 0.06,
          ),

          SizedBox(height: screenWidth * 0.02),

          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              color: fg.withOpacity(0.8),
            ),
          ),

          SizedBox(height: screenWidth * 0.01),

          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}