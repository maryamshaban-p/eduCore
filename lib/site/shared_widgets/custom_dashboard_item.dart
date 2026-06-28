import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class Custom_Dashboard_item extends StatelessWidget {
  const Custom_Dashboard_item({
    super.key,
    required this.screenWidth,
    required this.icon,
    required this.labelName,
    required this.isActive,
    required this.onTap,
    required this.isCollapsed,
    this.isHovered = false,
  });

  final double screenWidth;
  final IconData icon;
  final String labelName;
  final bool isActive;
  final VoidCallback onTap;
  final bool isCollapsed;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    final bg = isActive
        ? AppColors.primary.withOpacity(0.18)
        : isHovered
            ? Colors.white.withOpacity(0.06)
            : Colors.transparent;

    final iconColor = isActive ? Colors.white : AppColors.slate400;
    final textColor = isActive ? Colors.white : AppColors.slate400;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  labelName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}