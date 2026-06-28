import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.white,
      child: const Text(
        '© 2026 EduCore Educational System. All rights reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.slate600),
      ),
    );
  }
}
