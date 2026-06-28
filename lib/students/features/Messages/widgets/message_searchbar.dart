import 'package:flutter/material.dart';

class MessageSearchBar extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final ValueChanged<String> onChanged;

  const MessageSearchBar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      height: screenHeight * 0.06,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          /*Icon(Icons.search_rounded,
              color: textSecondary, size: screenWidth * 0.05),
*/
          SizedBox(width: screenWidth * 0.02),

          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TextStyle(
                fontSize: screenWidth * 0.037,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
                  ),
                ),
                disabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
                  ),
                ),
                hintText: "Search conversations...",
                hintStyle: TextStyle(
                  color: textSecondary,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}