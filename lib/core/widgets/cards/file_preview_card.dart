import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class FilePreviewCard extends StatelessWidget {
  const FilePreviewCard({
    super.key,
    required this.label,
    required this.fileName,
    required this.sizeMb,
  });

  final String label;
  final String fileName;
  final String sizeMb;

  @override
  Widget build(BuildContext context) {
    final fileNameStyle = AppTextStyles.caption(context).copyWith(
      fontSize: AppResponsive.scaleSize(context, 10),
      color: AppColors.grey,
      height: 1.2,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText(context).copyWith(
            fontSize: AppResponsive.scaleSize(context, 12),
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        AppSpacing.vertical(context, 0.006),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.scaleSize(context, 8),
            vertical: AppResponsive.scaleSize(context, 8),
          ),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 2),
            ),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AppIcons.image,
                size: AppResponsive.scaleSize(context, 56),
                color: AppColors.grey,
              ),
              AppSpacing.vertical(context, 0.004),
              Text(
                AppTexts.fileSizeMb(sizeMb),
                style: AppTextStyles.caption(
                  context,
                ).copyWith(fontSize: AppResponsive.scaleSize(context, 8)),
                textAlign: TextAlign.center,
              ),
              AppSpacing.vertical(context, 0.003),
              Text(
                fileName,
                style: fileNameStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.vertical(context, 0.006),
              const Divider(color: AppColors.cardBorder, height: 1),
              AppSpacing.vertical(context, 0.006),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    AppIcons.view,
                    color: AppColors.textPrimary,
                    size: AppResponsive.scaleSize(context, 18),
                  ),
                  Icon(
                    AppIcons.download,
                    color: AppColors.accentBlue,
                    size: AppResponsive.scaleSize(context, 18),
                  ),
                  Icon(
                    AppIcons.delete,
                    color: AppColors.error,
                    size: AppResponsive.scaleSize(context, 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
