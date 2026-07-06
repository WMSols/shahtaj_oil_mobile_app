import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppSubScreenScaffold extends StatelessWidget {
  const AppSubScreenScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            AppIcons.back,
            color: AppColors.primary,
            size: AppResponsive.iconSize(context),
          ),
          onPressed: Get.back,
        ),
        title: Text(title, style: AppTextStyles.heading(context)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.cardBorder),
        ),
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
