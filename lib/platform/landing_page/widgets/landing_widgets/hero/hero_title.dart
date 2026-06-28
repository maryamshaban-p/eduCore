import 'package:flutter/material.dart';

class HeroTitle extends StatelessWidget {
  final bool isMobile;
  const HeroTitle({super.key, required this.isMobile});
  @override
  Widget build(BuildContext context) {
    return Text('EduCore — The Bridge Between Teacher and Student',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Inter', fontSize: isMobile ? 26 : 32,
            fontWeight: FontWeight.w800, color: Colors.white, height: 1.15));
  }
}
