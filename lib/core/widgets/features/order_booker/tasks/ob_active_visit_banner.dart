import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';

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

    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                AppIcons.location5,
                color: AppColors.primary,
                size: AppResponsive.iconSize(context),
              ),
              AppSpacing.horizontal(context, 0.012),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTexts.obActiveVisitTitle,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppTexts.obActiveVisitAt(visit.shopName),
                      style: AppTextStyles.bodyText(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.012),
          AppPrimaryButton(label: AppTexts.obResumeVisit, onPressed: onResume),
        ],
      ),
    );
  }
}
