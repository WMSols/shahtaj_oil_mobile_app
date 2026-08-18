import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';

/// Compact cellular-style bars for device internet quality (app bar leading).
class AppNetworkSignalBars extends StatelessWidget {
  const AppNetworkSignalBars({super.key});

  static const _barCount = 4;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ConnectivityService>()) {
      return const SizedBox.shrink();
    }

    final width = AppResponsive.iconSize(context, factor: 1.2);
    final height = AppResponsive.iconSize(context, factor: 1.2);
    final gap = AppResponsive.scaleSize(context, 1.5);
    final barWidth = (width - gap * (_barCount - 1)) / _barCount;

    return Obx(() {
      final quality = Get.find<ConnectivityService>().quality.value;
      final active = switch (quality) {
        NetworkQuality.offline => 0,
        NetworkQuality.weak => 1,
        NetworkQuality.medium => 2,
        NetworkQuality.good => 4,
      };
      final color = switch (quality) {
        NetworkQuality.offline => AppColors.textMuted,
        NetworkQuality.weak => AppColors.error,
        NetworkQuality.medium => AppColors.warning,
        NetworkQuality.good => AppColors.success,
      };

      return SizedBox(
        width: width,
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < _barCount; i++) ...[
              if (i > 0) SizedBox(width: gap),
              _Bar(
                width: barWidth,
                height: height * ((i + 1) / _barCount),
                color: i < active ? color : AppColors.lightGrey,
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
