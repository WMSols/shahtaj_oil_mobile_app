import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/fonts/app_fonts.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';

class AppTextStyles {
  static TextStyle screenTitle(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.055,
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle headline(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.09,
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle heading(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.055,
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.04,
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle sectionTitleAccent(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.035,
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w600,
    color: AppColors.accentBlue,
  );

  static TextStyle bodyText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.038,
    fontFamily: AppFonts.mainFont,
    color: AppColors.textPrimary,
  );

  static TextStyle hintText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.026,
    fontFamily: AppFonts.mainFont,
    color: AppColors.textMuted,
  );

  static TextStyle buttonText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.scaleSize(context, 16),
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  /// Button label style for language pickers — always uses the native font.
  static TextStyle languagePickerButtonText(
    BuildContext context, {
    required bool urdu,
  }) => TextStyle(
    fontSize: AppResponsive.scaleSize(context, 16),
    fontFamily: urdu ? AppFonts.urdu : AppFonts.inter,
    fontWeight: FontWeight.w600,
  );

  static TextStyle labelText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.035,
    fontFamily: AppFonts.mainFont,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );

  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.03,
    fontFamily: AppFonts.mainFont,
    color: AppColors.textMuted,
  );

  static TextStyle errorText(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.035,
    fontFamily: AppFonts.mainFont,
    color: AppColors.error,
  );

  static TextStyle statValue(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.08,
    fontFamily: AppFonts.mainFont,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle statLabel(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.035,
    fontFamily: AppFonts.mainFont,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle welcomeSub(BuildContext context) => TextStyle(
    fontSize: AppResponsive.screenWidth(context) * 0.032,
    fontFamily: AppFonts.mainFont,
    color: AppColors.primary,
  );
}
