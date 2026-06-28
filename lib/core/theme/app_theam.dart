import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
class AppColors {
  static const primary          = Color(0xFF2170BE);
  static const primaryDark      = Color.fromARGB(255, 5, 50, 96);
  static const primaryLight     = Color.fromARGB(255, 124, 164, 204);
  static const backgroundDark   = Color(0xFF162D5A);
  static const backgroundLight  = Color(0xFF1E3A6E);
  static const primaryXL        = Color(0xFFEEF2FF);  // light tint for backgrounds

  static const slateDark900 = Color.fromARGB(255, 27, 41, 75);
  static const slateDark800 = Color.fromARGB(255, 39, 54, 78);

  static const slate900 = Color(0xFF0F172A);
  static const slate800 = Color(0xFF1E293B);
  static const slate700 = Color(0xFF334155);
  static const slate600 = Color(0xFF475569);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate300 = Color(0xFFCBD5E1);   // ← added (was lightGray / lightGrayBlue)
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50  = Color(0xFFF8FAFC);

  static const success   = Color(0xFF10B981);   // was greenColor  (0xFF22C55E → kept brighter one)
  static const successBg = Color(0xFFD1FAE5);
  static const warning   = Color(0xFFF59E0B);   // was orangeColor — identical value ✓
  static const warningBg = Color(0xFFFEF3C7);
  static const danger    = Color(0xFFEF4444);   // was redColor (0xFFFF5B59) — more standard red
  static const dangerBg  = Color(0xFFFEE2E2);
  static const info      = Color(0xFF3B82F6);   // was blueColor — identical value ✓
  static const infoBg    = Color(0xFFDBEAFE);
  static const premium   = Color(0xFF8B5CF6);
  static const premiumBg = Color(0xFFEDE9FE);

  static const teal         = Color(0xFF06B6D4);   // was tealColor
  static const tealBg       = Color(0xFFCCFBF1);
  static const deepBlue     = Color(0xFF3949AB);   // was deepBlue
  static const mediumPurple = Color(0xFF6366F1);   // was meduimBlue / charts[0]
  static const goldenBrown  = Color(0xFFC47C1C);   // was goldenBrown
  static const deepRose     = Color(0xFFD84379);   // was deepRose
  static const deepGreen    = Color(0xFF4B9069);   // was deepGreen
  static const jungleGreen  = Color(0xFF2CA58D);   // was jungleGreen
  static const deepRed      = Color(0xFFBE3C3F);   // was deepRed

  static const List<Color> charts = [
    Color(0xFF6366F1),  // mediumPurple
    Color(0xFF14B8A6),
    Color(0xFFF59E0B),  // warning
    Color(0xFFEC4899),
    Color(0xFF06B6D4),  // teal
  ];
}

const _inter = 'Inter';

ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      scaffoldBackgroundColor: AppColors.slate50,
      fontFamily: _inter,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.slate50,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: _inter,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.slate800,
        ),
        iconTheme: IconThemeData(color: AppColors.slate700),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontFamily: _inter,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 14),
      ),
      dividerColor: AppColors.slate200,
    );

    ThemeData buildDarkAppTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      fontFamily: _inter,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
      ),

      scaffoldBackgroundColor: const Color(0xFF121212),

      cardColor: const Color(0xFF242424),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: _inter,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF242424),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: _inter,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF242424),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF3A3A3A),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF3A3A3A),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),

      dividerColor: const Color(0xFF3A3A3A),

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );

    class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}