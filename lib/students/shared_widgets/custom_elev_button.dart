import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CoustomElevatedButton2 extends StatelessWidget {
  CoustomElevatedButton2(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.bgColor,
      this.buttonSize,
      this.borderColor,
      required this.buttonTextStyle});

  final String label;
  final Color bgColor;
  final TextStyle buttonTextStyle;
  final VoidCallback? onPressed;
  double? buttonSize;
  Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: buttonSize != null
              ? Size.fromWidth(buttonSize!) // Size(buttonSize!, buttonSize!)
              : Size.fromWidth(
                  double.infinity), //const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
              side: BorderSide( color: borderColor ?? AppColors.primaryColor,),
              borderRadius: BorderRadius.circular(8)),
          backgroundColor: bgColor),
      onPressed: onPressed,
      child: Text(label,
          style: //
              buttonTextStyle //(color: textColor,fontWeight:textWeight ),
          ),
    );
  }
}
