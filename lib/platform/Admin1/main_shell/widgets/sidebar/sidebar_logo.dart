import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class SidebarLogo extends StatelessWidget {
  final double fadeValue;
  const SidebarLogo({super.key, required this.fadeValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        _LogoIcon(),
        if (fadeValue > 0) ...[
          const SizedBox(width: 12),
          Expanded(child: _LogoText(fadeValue: fadeValue)),
        ],
      ]),
    );
  }
}

class _LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
      child: const Icon(Icons.school_outlined, color: Colors.white, size: 20),
    );
  }
}

class _LogoText extends StatelessWidget {
  final double fadeValue;
  const _LogoText({required this.fadeValue});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: fadeValue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('EduCore',
              style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          Text('Al-Nour Educational Center',
              style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white.withValues(alpha: 0.5)),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
