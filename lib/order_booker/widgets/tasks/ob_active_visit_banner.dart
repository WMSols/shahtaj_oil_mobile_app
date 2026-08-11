import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_active_visit_model.dart';

class ObActiveVisitBanner extends StatelessWidget {
  const ObActiveVisitBanner({
    super.key,
    required this.visit,
    required this.onResume,
  });

  final ObActiveVisitModel visit;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    final iconPad = AppResponsive.scaleSize(context, 8);

    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(iconPad),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Icon(
                  AppIcons.location5,
                  color: AppColors.white,
                  size: AppResponsive.iconSize(context),
                ),
              ),
              AppSpacing.horizontal(context, 0.012),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTexts.obActiveVisitTitle,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppTexts.obActiveVisitAt(visit.shopName),
                      style: AppTextStyles.bodyText(context).copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.012),
          AppSecondaryButton(
            label: AppTexts.obResumeVisit,
            onPressed: onResume,
            borderColor: AppColors.white,
            textColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
