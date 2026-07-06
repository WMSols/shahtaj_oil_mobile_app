import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel,
    this.cancelLabel,
  });

  final String title;
  final String message;
  final String? confirmLabel;
  final String? cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: AppSpacing.symmetric(context, h: 0.06, v: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 2),
        ),
      ),
      child: Padding(
        padding: AppSpacing.all(context, factor: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTextStyles.heading(context),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vertical(context, 0.012),
            Text(
              message,
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vertical(context, 0.02),
            AppPrimaryButton(
              label: confirmLabel ?? AppTexts.confirm,
              onPressed: () => Get.back(result: true),
            ),
            AppSpacing.vertical(context, 0.008),
            AppSecondaryButton(
              label: cancelLabel ?? AppTexts.cancel,
              outlinedOnly: true,
              onPressed: () => Get.back(result: false),
            ),
          ],
        ),
      ),
    );
  }
}
