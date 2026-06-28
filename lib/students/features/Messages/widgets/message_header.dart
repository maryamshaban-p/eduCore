import 'package:flutter/material.dart';

class MessageHeader extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const MessageHeader({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).cardColor.withValues(alpha: 0.6),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: screenWidth * 0.05,
                color: textColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                "Messages",
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).cardColor.withValues(alpha: 0.6),
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                size: screenWidth * 0.06,
                color: textColor,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}