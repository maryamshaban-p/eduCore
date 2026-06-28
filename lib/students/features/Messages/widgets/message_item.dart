import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String name;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final VoidCallback onTap;

  const MessageItem({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.name,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.onTap,
  });

  String _getInitials(String fullName) {
    final parts =
        fullName.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return "?";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Color _bg(String name) {
    return const Color(0xFFEEF2FF);
  }

  Color _fg(String name) {
    return const Color(0xFF4F46E5);
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final hasUnread = unreadCount > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
       margin: const EdgeInsets.only(top: 4),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color.fromARGB(255, 89, 198, 228),
        Color.fromARGB(255, 124, 146, 247),
      ],
    ),
    borderRadius: BorderRadius.circular(20),

    border: Border.all(
      color: const Color(0xFF1D9E75).withOpacity(0.6),
      width: 1.2,
    ),

    boxShadow: [
      BoxShadow(
        color: const Color(0xFF1D9E75).withOpacity(0.25),
        blurRadius: 8,
        offset: const Offset(0, 3),
        ),
        ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                  )
                ],
              ),
              child: CircleAvatar(
                radius: screenWidth * 0.06,
                backgroundColor: _bg(name),
                child: Text(
                  _getInitials(name),
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w700,
                    color: _fg(name),
                  ),
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.03),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,

                            fontWeight:
                                hasUnread ? FontWeight.w800 : FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),  
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: hasUnread
                              ? const Color(0xFF378ADD)
                              : AppColors.whiteColor,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.005),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: screenWidth * 0.034,
                            color: AppColors.whiteColor,
                          //  color: hasUnread ? textPrimary : textSecondary,
                            fontWeight:
                                hasUnread ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),

                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.004,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF378ADD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            unreadCount > 9 ? "9+" : "$unreadCount",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.028,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}