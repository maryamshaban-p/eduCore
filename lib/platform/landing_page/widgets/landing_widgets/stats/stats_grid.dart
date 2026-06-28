import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

const kStats = [
  ('50K+', 'Active Students'),
  ('2K+',  'Academies'),
  ('98%',  'Satisfaction Rate'),
  ('24/7', 'Support'),
];

class StatsGrid extends StatelessWidget {
  final bool isMobile;
  const StatsGrid({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 40, runSpacing: 30,
      children: kStats.map((s) => _StatItem(value: s.$1, label: s.$2, isMobile: isMobile)).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final bool isMobile;
  const _StatItem({required this.value, required this.label, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: TextStyle(fontFamily: 'Inter',
          fontSize: isMobile ? 28 : 36, fontWeight: FontWeight.w800, color: Colors.white)),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.slate400)),
    ]);
  }
}
