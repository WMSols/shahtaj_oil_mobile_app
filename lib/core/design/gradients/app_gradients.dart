import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';

class AppGradients {
  AppGradients._();

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
  );

  static const cardOverlay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8F9FC), Color(0xFFEEF2F7)],
  );

  static const primaryCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  );
}
