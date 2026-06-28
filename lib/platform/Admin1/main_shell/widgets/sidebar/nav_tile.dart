import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'nav_item_model.dart';

class NavTile extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final bool isHovered;
  final double fadeValue;
  final VoidCallback onTap;
  final VoidCallback onEnter;
  final VoidCallback onExit;

  const NavTile({
    super.key,
    required this.item,
    required this.isActive,
    required this.isHovered,
    required this.fadeValue,
    required this.onTap,
    required this.onEnter,
    required this.onExit,
  });

  Color get _bgColor {
    if (isActive)  return AppColors.primary.withValues(alpha: 0.45);
    if (isHovered) return Colors.white.withValues(alpha: 0.1);
    return Colors.transparent;
  }

  Color get _contentColor =>
      isActive ? Colors.white : Colors.white.withValues(alpha: 0.6);

  bool get _isCollapsed => fadeValue < 0.1;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEnter(),
      onExit:  (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.symmetric(
            horizontal: 12.0 * fadeValue,
            vertical: 10,
          ),
          decoration: BoxDecoration(
              color: _bgColor, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: _isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(item.icon, size: 20, color: _contentColor),
              if (fadeValue > 0.01) ...[
                SizedBox(width: 12 * fadeValue),
                Opacity(
                  opacity: fadeValue,
                  child: Text(item.label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: _contentColor,
                      )),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}