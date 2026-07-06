import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppPhotoUploadTile extends StatelessWidget {
  const AppPhotoUploadTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.imageBytes,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Uint8List? imageBytes;
  final VoidCallback? onTap;

  bool get _hasImage => imageBytes != null && imageBytes!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: _hasImage ? AppColors.primary : AppColors.lightGrey,
              width: _hasImage ? 2 : 1.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_hasImage)
                Image.memory(imageBytes!, fit: BoxFit.cover)
              else
                Center(
                  child: Padding(
                    padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: AppColors.grey,
                          size: AppResponsive.iconSize(context, factor: 1.4),
                        ),
                        AppSpacing.vertical(context, 0.008),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AppSpacing.vertical(context, 0.003),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.hintText(context),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_hasImage) ...[
                Container(color: AppColors.black.withValues(alpha: 0.35)),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: AppColors.white,
                        size: AppResponsive.iconSize(context),
                      ),
                      AppSpacing.vertical(context, 0.006),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption(context).copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.hintText(context).copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: AppSpacing.verticalValue(context, 0.008),
                  right: AppSpacing.horizontalValue(context, 0.02),
                  child: Container(
                    padding: EdgeInsets.all(
                      AppResponsive.scaleSize(context, 4),
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: AppResponsive.scaleSize(context, 14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
