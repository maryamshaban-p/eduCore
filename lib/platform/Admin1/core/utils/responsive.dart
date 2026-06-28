import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile  = 600;
  static const double tablet  = 900;

  static bool isMobile(BuildContext context)  => MediaQuery.sizeOf(context).width < mobile;
  static bool isTablet(BuildContext context)  => MediaQuery.sizeOf(context).width < tablet;
}

double panelWidth(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  if (w < Breakpoints.mobile) return w;      
  if (w < Breakpoints.tablet) return w * 0.6; 
  return 420;                                   
}
