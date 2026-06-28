import 'package:edulink_app/utils/responsive_fontSize_method.dart';
import 'package:flutter/material.dart';
import 'package:edulink_app/utils/app_colors.dart';

class AppStyles {
    static TextStyle black40 = TextStyle(
        fontWeight: FontWeight.w700, 
        fontSize: getResponsiveFontSize( fontsize: 40),
        color: AppColors.blackColor,
  );
     static TextStyle black25 = TextStyle(
   fontFamily: 'Segoe UI Variable',
        fontWeight: FontWeight.w400,  
        fontSize: getResponsiveFontSize( fontsize: 25),
        color: AppColors.blackColor,           
  );
      static TextStyle black24 = TextStyle(
         fontFamily: 'Poppins',
    fontWeight: FontWeight.w500, 
    fontSize: getResponsiveFontSize( fontsize: 24),
    height: 0,
        color: AppColors.blackColor,           
  );
       static TextStyle black20 = TextStyle(
       fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
    fontSize:getResponsiveFontSize( fontsize: 20), 
        color: AppColors.blackColor,           
  );
      static TextStyle black15 = TextStyle(
     fontFamily: 'Poppins',
    fontWeight: FontWeight.w600, 
    fontSize: getResponsiveFontSize( fontsize: 15),
        color: AppColors.blackColor,           
  );
       static TextStyle black12 = TextStyle(
     fontFamily: 'Poppins',
    fontWeight: FontWeight.w600, 
    fontSize: getResponsiveFontSize( fontsize: 12),
        color: AppColors.blackColor,           
  );
       static TextStyle backgroundColor= TextStyle(
     fontFamily: 'Poppins',
    fontWeight: FontWeight.w600, 
    fontSize: getResponsiveFontSize( fontsize: 16),
        color: AppColors.blackColor,           
  );
     static TextStyle black36 = TextStyle(
        fontFamily: 'DM Sans',
        fontWeight: FontWeight.w400,  
        fontSize: getResponsiveFontSize( fontsize: 36),
        color: AppColors.blackColor,           
  );
      static TextStyle primaryColor24 = TextStyle(
        fontFamily: 'Inter',         
    fontWeight: FontWeight.w500, 
    fontSize: getResponsiveFontSize( fontsize: 24),
        color: AppColors.primaryColor,           
  );
     static TextStyle lightGray16 = TextStyle(
       fontFamily: 'Poppins',       
    fontWeight: FontWeight.w500, 
    fontSize: getResponsiveFontSize( fontsize: 16),
        color: AppColors.lightGray,           
  );
     static TextStyle whiteColor40= TextStyle(
       fontFamily: 'Poppins',
    fontWeight: FontWeight.w500, 
    fontSize: getResponsiveFontSize( fontsize: 40),
        color: AppColors.whiteColor,           
  );
   static TextStyle coalGray12= TextStyle(
       fontFamily: 'Poppins',
    fontWeight: FontWeight.w100, 
    fontSize: getResponsiveFontSize( fontsize: 11),
        color:    Color(0xFF7D8388)        
  );

     static TextStyle charcoalGray= TextStyle(
       fontFamily: 'Inter',
    fontWeight: FontWeight.w300,
    fontSize: getResponsiveFontSize( fontsize: 18),
        color: AppColors.charcoalGray,           
  );
   static TextStyle whiteColor13= TextStyle(
       fontFamily: 'Poppins',
    fontWeight: FontWeight.w400, 
    fontSize: getResponsiveFontSize( fontsize: 13),
        color: AppColors.whiteColor,           
  );
      static TextStyle whiteColor20= TextStyle(
     fontFamily: 'Inter',
    fontWeight: FontWeight.w400, 
    fontSize: getResponsiveFontSize( fontsize: 20),
        color: AppColors.whiteColor,           
  );
       static TextStyle mediumGrayBlue20= TextStyle(
     fontFamily: 'Poppins',
    fontWeight: FontWeight.w400, 
    fontSize: getResponsiveFontSize( fontsize: 20),
        color: AppColors.darkGrayBlue,           
  );
     static TextStyle whiteColor24= TextStyle(
      fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: getResponsiveFontSize( fontsize: 24),
        color: AppColors.whiteColor,           
  );
     static TextStyle whiteColor18 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: getResponsiveFontSize( fontsize: 18),
    color: AppColors.whiteColor,
  );
    static TextStyle whiteColor16= TextStyle(
     fontFamily: 'Poppins',
    fontWeight: FontWeight.w500, 
    fontSize: getResponsiveFontSize( fontsize: 16),
        color: AppColors.whiteColor,           
  );
      static TextStyle blueColor= TextStyle(
      fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: getResponsiveFontSize( fontsize: 20),
        color: AppColors.blueColor,           
  );
        static TextStyle coalGray= TextStyle(
      fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: getResponsiveFontSize( fontsize: 20),
        color: AppColors.coalGray,           
  );
    static TextStyle primary30 = TextStyle(
    fontFamily: 'Segoe UI Variable',
    fontWeight: FontWeight.w700,
    fontSize: getResponsiveFontSize( fontsize: 30),
    height: 50 / 40,
    letterSpacing: 0,
    color: AppColors.primaryColor,
  );
  static TextStyle primary20 = TextStyle(
    fontFamily: 'poppins',
    fontWeight: FontWeight.w500,
    fontSize: getResponsiveFontSize( fontsize: 20),
    color: AppColors.primaryColor,
  );
    static TextStyle primary16 = TextStyle(
    fontFamily: 'Segoe UI Variable',
    fontWeight: FontWeight.w400,
    fontSize:getResponsiveFontSize( fontsize: 16), 
    color: AppColors.primaryColor,
  );

   static TextStyle lightBlueGray35 = TextStyle(
        fontWeight: FontWeight.w500, 
        fontSize: getResponsiveFontSize( fontsize: 35),
        color: AppColors.lightBlueGray,
  );
   
}