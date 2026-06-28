import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class HeroSubtitle extends StatelessWidget {
  final bool isMobile;
  const HeroSubtitle({super.key, required this.isMobile});
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Text(
        'EduCore is an e-learning system that connects teachers and students, providing all the integrated solutions to deliver educational services easily from anywhere — with a seamless experience and continuous technical support.',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Inter', fontSize: isMobile ? 16 : 18,
            color: AppColors.slate200, height: 1.7),
      ),
    );
  }
}
