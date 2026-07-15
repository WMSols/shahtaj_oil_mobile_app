import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';

class ObShopDetailHero extends StatelessWidget {
  const ObShopDetailHero({super.key, this.imageAsset});

  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageAsset != null && imageAsset!.trim().isNotEmpty;

    return SizedBox(
      height: AppResponsive.screenHeight(context) * 0.3,
      width: double.infinity,
      child: hasImage
          ? Image.asset(imageAsset!, fit: BoxFit.cover)
          : ColoredBox(
              color: AppColors.inputFill,
              child: Center(
                child: Icon(
                  AppIcons.image5,
                  color: AppColors.grey,
                  size: AppResponsive.iconSize(context, factor: 2.2),
                ),
              ),
            ),
    );
  }
}
