import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title, description;
  const FeatureCard({super.key, required this.icon, required this.title, required this.description});

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(24),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.slate200),
          boxShadow: _hovered
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _FeatureIcon(icon: widget.icon),
          const SizedBox(height: 16),
          Text(widget.title, style: const TextStyle(fontFamily: 'Inter', fontSize: 16,
              fontWeight: FontWeight.w600, color: AppColors.slate800)),
          const SizedBox(height: 8),
          Text(widget.description, style: const TextStyle(fontFamily: 'Inter', fontSize: 14,
              color: AppColors.slate600, height: 1.6)),
        ]),
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  const _FeatureIcon({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.primaryXL, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: AppColors.primary, size: 22),
    );
  }
}
