import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'features/features_grid.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
      color: AppColors.slate50,
      child: const Column(children: [
        Text('EduCore Educational System',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 32,
                fontWeight: FontWeight.w700, color: AppColors.slate900)),
        SizedBox(height: 12),
        Text(
          'A premium learning experience for you and your students — deliver your educational services in a distinctive way.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: AppColors.slate600),
        ),
        SizedBox(height: 56),
        FeaturesGrid(),
      ]),
    );
  }
}
