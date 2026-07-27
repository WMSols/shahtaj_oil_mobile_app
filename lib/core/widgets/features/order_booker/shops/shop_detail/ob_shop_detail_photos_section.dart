import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/media/app_ref_image.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';

class ObShopDetailPhotosSection extends StatelessWidget {
  const ObShopDetailPhotosSection({super.key, required this.shop});

  final ObShopModel shop;

  @override
  Widget build(BuildContext context) {
    final photos = shop.verificationPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.obVerificationPhotosSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.012),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.horizontalValue(context, 0.02),
          mainAxisSpacing: AppSpacing.verticalValue(context, 0.012),
          childAspectRatio: 0.85,
          children: [
            ObPhotoPreviewTile(
              label: AppTexts.obCnicFrontLabel,
              asset: photos.cnicFront,
            ),
            ObPhotoPreviewTile(
              label: AppTexts.obCnicBackLabel,
              asset: photos.cnicBack,
            ),
            ObPhotoPreviewTile(
              label: AppTexts.obOwnerPhotoLabel,
              asset: photos.ownerPhoto,
            ),
            ObPhotoPreviewTile(
              label: AppTexts.obShopExteriorLabel,
              asset: photos.shopExterior,
            ),
          ],
        ),
      ],
    );
  }
}

class ObPhotoPreviewTile extends StatelessWidget {
  const ObPhotoPreviewTile({
    super.key,
    required this.label,
    required this.asset,
  });

  final String label;
  final String? asset;

  static const double _borderWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    final hasImage = AppRefImage.isLoadable(asset);

    return Column(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: hasImage ? AppColors.primary : AppColors.lightGrey,
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
                  if (hasImage)
                    SizedBox.expand(
                      child: AppRefImage(ref: asset, fit: BoxFit.cover),
                    )
                  else
                    Center(
                      child: Icon(
                        AppIcons.image5,
                        color: AppColors.grey,
                        size: AppResponsive.iconSize(context, factor: 1.4),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        AppSpacing.vertical(context, 0.008),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
            fontSize: AppResponsive.scaleSize(context, 12),
          ),
        ),
      ],
    );
  }
}
