import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/landing_page/views/login.dart';
import 'package:flutter/material.dart';

class HeroStartButton extends StatelessWidget {
  const HeroStartButton({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: ElevatedButton(
       onPressed: () => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const LoginPage())),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(20),
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Start', style: TextStyle(fontWeight: FontWeight.w100)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 18),
        ]),
      ),
    );
  }
}
