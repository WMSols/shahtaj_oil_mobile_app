import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppFormSectionText extends StatelessWidget {
  const AppFormSectionText(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.hintText(context).copyWith(
        fontSize: AppResponsive.screenWidth(context) * 0.03,
        color: color,
      ),
    );
  }
}
