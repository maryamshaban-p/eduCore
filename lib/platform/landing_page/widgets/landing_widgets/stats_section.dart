import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'stats/stats_grid.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final isMobile = c.maxWidth < 700;
      return _GradientSection(child: Column(children: [
        Text('EduCore by the Numbers', textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: isMobile ? 28 : 38,
                fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 560),
          child: Text('What EduCore has achieved so far', textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: isMobile ? 16 : 18,
                  color: AppColors.slate200, height: 1.7)),
        ),
        const SizedBox(height: 40),
        StatsGrid(isMobile: isMobile),
      ]));
    });
  }
}

class _GradientSection extends StatelessWidget {
  final Widget child;
  const _GradientSection({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight,
            colors: [AppColors.backgroundLight, AppColors.backgroundDark]),
      ),
      child: child,
    );
  }
}
