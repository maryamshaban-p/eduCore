import 'package:flutter/material.dart';
import 'screen_config.dart';

double getResponsiveFontSize({required double fontsize}) {
  double scaleFactor = getScaleFactor();
  double responsiveFontSize = fontsize * scaleFactor;

  double lowerLimit = fontsize * 0.8;
  double upperLimit = fontsize * 1.2;

  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor() {
  double width = MediaQuery.sizeOf(ScreenConfig.context).width;

  if (width < 600) {
    return width / 400;
  } else if (width < 900) {
    return width / 700;
  } else {
    return width / 1000;
  }
}
