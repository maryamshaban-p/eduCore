import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTopCard extends StatelessWidget {
  const CustomTopCard({
    super.key,
    required this.h,
    required this.w,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.onTap,
  });

  final double h;
  final double w;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final iconRadius = (cardWidth * 0.10).clamp(18.0, 32.0);
        final titleSize = (cardWidth * 0.085).clamp(13.0, 18.0);
        final subtitleSize = (cardWidth * 0.065).clamp(10.0, 14.0);
        final iconSize = (cardWidth * 0.07).clamp(14.0, 22.0);
        final padding = (cardWidth * 0.06).clamp(10.0, 20.0);
        final borderRadius = (cardWidth * 0.06).clamp(12.0, 20.0);

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: Colors.white24,
            highlightColor: Colors.white12,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: padding * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: iconRadius,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        icon,
                        color: AppColors.whiteColor,
                        size: iconSize,
                      ),
                    ),
                    SizedBox(height: padding * 0.5),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}