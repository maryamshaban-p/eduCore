import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.buttonWidth,
    required this.textStyle,
    this.buttonHeight,
    this.borderRadius,
    required this.onPressed,
    this.child,
  });

  final String label;
  final Color bgColor, textColor;
  final TextStyle? textStyle;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? borderRadius;
  final void Function()? onPressed;
  final Widget? child; 

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: textStyle,
        fixedSize: Size(
          buttonWidth ?? MediaQuery.of(context).size.width,
          buttonHeight ?? MediaQuery.of(context).size.height,
        ),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(borderRadius ?? 8)),
        backgroundColor: bgColor,
      ),
      onPressed: onPressed,
      child: child ?? Text(label, style: TextStyle(color: textColor)),
    );
  }
}