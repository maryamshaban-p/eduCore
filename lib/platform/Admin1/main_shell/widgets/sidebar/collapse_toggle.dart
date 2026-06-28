import 'package:flutter/material.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';

class CollapseToggle extends StatelessWidget {
  final bool collapsed;
  final VoidCallback onTap;
  const CollapseToggle({super.key, required this.collapsed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        color: Colors.white.withValues(alpha: 0.04),
        child: Center(
          child: Icon(
            // موبايل: أيقونة X للإغلاق
            // ديسكتوب: سهم يمين أو يسار حسب الحالة
            isMobile
                ? Icons.chevron_left_rounded
                : collapsed
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
            color: Colors.white38,
            size: 20,
          ),
        ),
      ),
    );
  }
}