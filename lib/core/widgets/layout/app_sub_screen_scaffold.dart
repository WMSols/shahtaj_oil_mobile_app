import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_sync_status_banner.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_version_badge.dart';

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
        centerTitle: true,
        leadingWidth: AppResponsive.screenWidth(context) * 0.28,
        leading: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.horizontalValue(context, 0.005),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  AppIcons.back,
                  color: AppColors.primary,
                  size: AppResponsive.iconSize(context),
                ),
                // maybePop respects PopScope (e.g. leave-visit confirm); Get.back force-pops.
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const AppVersionBadge(),
            ],
          ),
        ),
        title: Text(title, style: AppTextStyles.screenTitle(context)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.cardBorder),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const AppSyncStatusBanner(),
            Expanded(child: body),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
