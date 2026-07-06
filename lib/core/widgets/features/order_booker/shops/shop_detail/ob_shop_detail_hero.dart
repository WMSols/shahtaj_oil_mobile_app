import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';

class ObShopDetailHero extends StatelessWidget {
  const ObShopDetailHero({super.key, required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppResponsive.screenHeight(context) * 0.3,
      width: double.infinity,
      child: Image.asset(imageAsset, fit: BoxFit.cover),
    );
  }
}
