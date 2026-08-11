import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/media/app_ref_image.dart';

class ObShopDetailHero extends StatelessWidget {
  const ObShopDetailHero({super.key, this.imageAsset, this.isLoading = false});

  /// Shop exterior image only (null → placeholder).
  final String? imageAsset;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final height = AppResponsive.screenHeight(context) * 0.3;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: isLoading && !AppRefImage.isLoadable(imageAsset)
          ? AppShimmer(child: AppShimmer.box(height: height, radius: 0))
          : AppRefImage(
              ref: imageAsset,
              fit: BoxFit.cover,
              placeholder: ColoredBox(
                color: AppColors.inputFill,
                child: Center(
                  child: Icon(
                    AppIcons.image5,
                    color: AppColors.grey,
                    size: AppResponsive.iconSize(context, factor: 2.2),
                  ),
                ),
              ),
            ),
    );
  }
}
