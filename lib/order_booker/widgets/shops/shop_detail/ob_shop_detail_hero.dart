import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/media/app_ref_image.dart';

class ObShopDetailHero extends StatelessWidget {
  const ObShopDetailHero({super.key, this.imageAsset});

  /// Shop exterior image only (null → placeholder).
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppResponsive.screenHeight(context) * 0.3,
      width: double.infinity,
      child: AppRefImage(
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
