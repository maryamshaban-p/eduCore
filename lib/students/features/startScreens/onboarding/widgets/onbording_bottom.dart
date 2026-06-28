import 'package:flutter/material.dart';

class OnbordinBotton extends StatelessWidget {
   OnbordinBotton({
    super.key,required this.onbordingIcon,required this.iconColor,required this.backgroundColor
  });
IconData onbordingIcon;
Color iconColor,backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12), // مسافة داخلية
      height: 45,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: 
          
          Icon(onbordingIcon, size: 28, color: iconColor),
      
      
    );
  }
}
