import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'hero/hero_start_button.dart';
import 'hero/hero_subtitle.dart';
import 'hero/hero_title.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 50, vertical: 96),
      decoration: const BoxDecoration(
        gradient: RadialGradient(center: Alignment.center, radius: 1,
            colors: [AppColors.backgroundLight, AppColors.backgroundDark]),
      ),
      child: Column(children: [
        const SizedBox(height: 24),
        HeroTitle(isMobile: isMobile),
        const SizedBox(height: 20),
        HeroSubtitle(isMobile: isMobile),
        const SizedBox(height: 40),
        const HeroStartButton(),
      ]),
    );
  }
}
