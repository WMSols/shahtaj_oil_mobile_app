import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
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
    this.required = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Uint8List? imageBytes;
  final VoidCallback? onTap;
  final bool required;

  static const double _borderWidth = 1.5;

  bool get _hasImage => imageBytes != null && imageBytes!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    final titleColor = _hasImage ? AppColors.white : AppColors.grey;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: _hasImage ? AppColors.primary : AppColors.lightGrey,
              width: _borderWidth,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              (radius - _borderWidth).clamp(0, radius),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_hasImage)
                  Image.memory(
                    imageBytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    gaplessPlayback: true,
                  ),
                if (!_hasImage)
                  Center(
                    child: Padding(
                      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            color: AppColors.grey,
                            size: AppResponsive.iconSize(context, factor: 1.4),
                          ),
                          AppSpacing.vertical(context, 0.008),
                          _titleRow(context, titleColor),
                          AppSpacing.vertical(context, 0.003),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.hintText(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_hasImage) ...[
                  const ColoredBox(color: Color(0x59000000)),
                  Center(
                    child: Padding(
                      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            color: AppColors.white,
                            size: AppResponsive.iconSize(context, factor: 1.4),
                          ),
                          AppSpacing.vertical(context, 0.008),
                          _titleRow(context, AppColors.white),
                          AppSpacing.vertical(context, 0.003),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.hintText(context).copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
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
                        AppIcons.check,
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
      ),
    );
  }

  Widget _titleRow(BuildContext context, Color titleColor) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: titleColor, fontWeight: FontWeight.w700),
          ),
          if (required)
            TextSpan(
              text: ' *',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.error, fontWeight: FontWeight.w700),
            ),
        ],
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
