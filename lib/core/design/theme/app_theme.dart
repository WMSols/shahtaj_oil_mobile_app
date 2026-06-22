import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/fonts/app_fonts.dart';
import 'package:shahtaj_oil_mobile_app/core/design/system/app_system_ui.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => light;

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppFonts.mainFont,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.accentBlue,
      surface: AppColors.cardDark,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      systemOverlayStyle: AppSystemUi.overlayStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentBlue,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    ),
  );
}
