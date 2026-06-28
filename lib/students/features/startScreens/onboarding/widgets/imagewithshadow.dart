import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// ودجت جاهزة 100% لأي إليستريشن مع شادو من تحت زي الـ Onboarding بالضبط
class ImageWithShadow extends StatelessWidget {
  final String imagePath;       // مسار الصورة
  final double size;            // العرض والطول (مربعة عادةً)
  final double shadowOffsetY;   // كم تبعد الظل لتحت (غالبًا 15-25)
  final double blurX;           // نعومة أفقي (20-30)
  final double blurY;           // نعومة رأسي (30-45)
  final double shadowOpacity;   // كثافة الظل (0.3 - 0.45)

  const ImageWithShadow({
    Key? key,
    required this.imagePath,
    required this.size,
    this.shadowOffsetY = 20,
    this.blurX = 25,
    this.blurY = 38,
    this.shadowOpacity = 0.38,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     // width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الشادو اللي بيتبع شكل الصورة بالكامل
          Transform.translate(
            offset: Offset(0, shadowOffsetY),
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
              child: Opacity(
                opacity: shadowOpacity,
                child: Image.asset(
                  imagePath,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  color: Colors.black,
                  colorBlendMode: BlendMode.srcATop,
                ),
              ),
            ),
          ),

          // الصورة الأصلية
          Image.asset(
            imagePath,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}