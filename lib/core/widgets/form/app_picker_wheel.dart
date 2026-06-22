import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppPickerWheel extends StatelessWidget {
  const AppPickerWheel({
    super.key,
    required this.controller,
    required this.count,
    required this.onChanged,
    required this.itemBuilder,
  });

  final FixedExtentScrollController controller;
  final int count;
  final ValueChanged<int> onChanged;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppResponsive.scaleSize(context, 56),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: AppResponsive.scaleSize(context, 44),
        diameterRatio: 1.2,
        perspective: 0.003,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (context, index) =>
              Center(child: itemBuilder(context, index)),
        ),
      ),
    );
  }
}

class AppPickerWheelLabel extends StatelessWidget {
  const AppPickerWheelLabel({
    super.key,
    required this.text,
    required this.selected,
  });

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyText(context).copyWith(
        color: selected ? AppColors.textPrimary : AppColors.grey,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
