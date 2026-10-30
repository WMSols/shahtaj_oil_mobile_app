import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/config/app_region_config.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';

/// Distributor region chip for Auth, Onboarding, and Account.
class AppRegionLabel extends StatelessWidget {
  const AppRegionLabel({super.key, this.centered = false});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    final chip = AppStatusChip(
      label: AppRegionConfig.regionDisplayName,
      color: AppColors.primary,
    );

    if (!centered) return chip;
    return Center(child: chip);
  }
}
