import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_build_info.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

/// Compact primary badge (`V8`) so QA can confirm which build is installed.
class AppVersionBadge extends StatelessWidget {
  const AppVersionBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.horizontalValue(context, 0.015),
        vertical: AppSpacing.verticalValue(context, 0.004),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 0.5),
        ),
      ),
      child: Text(
        AppBuildInfo.versionLabel,
        style: AppTextStyles.caption(context).copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }
}
