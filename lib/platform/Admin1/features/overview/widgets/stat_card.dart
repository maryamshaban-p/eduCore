import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color iconColor, iconBg;

  const StatCard({super.key, required this.title, required this.value,
      required this.icon, required this.iconColor, required this.iconBg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.slate200)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _StatInfo(title: title, value: value)),
          const SizedBox(width: 12),
          _StatIcon(icon: icon, color: iconColor, bg: iconBg),
        ],
      ),
    );
  }
}

class _StatInfo extends StatelessWidget {
  final String title, value;
  const _StatInfo({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 13,
              color: AppColors.slate500, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Text(value, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 32,
              fontWeight: FontWeight.w700, color: AppColors.slate900)),
    ]);
  }
}

class _StatIcon extends StatelessWidget {
  final IconData icon;
  final Color color, bg;
  const _StatIcon({required this.icon, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
