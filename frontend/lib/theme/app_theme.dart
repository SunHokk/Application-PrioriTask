import 'package:flutter/material.dart';

class AppColors {

  static const Color primary = Color(0xFF5B78C4);
  static const Color primaryLight = Color(0xFF8FA5E0);
  static const Color primaryDark = Color(0xFF3D5BA8);

  static const Color gold = Color(0xFFC9A030);
  static const Color goldLight = Color(0xFFFAF0D0);

  static const Color accentOrange = Color(0xFFFF7043);
  static const Color accentPurple = Color(0xFF7C4DFF);

  static const Color background = Color(0xFFF3F0E8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1A2340);
  static const Color textSecondary = Color(0xFF6B7A99);
  static const Color textHint = Color(0xFFADB5C7);
  static const Color divider = Color(0xFFEDE9DE);
  
  static const Color urgent = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFB300);
  static const Color success = Color(0xFF00C896);
  static const Color easy = Color(0xFF00C896);
  static const Color medium = Color(0xFFFFB300);
  static const Color hard = Color(0xFFFF4757);

  static const Color navBarBg = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x1A5B78C4);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintStyle: const TextStyle(
            color: AppColors.textHint,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.navBarBg,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.textHint,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}
