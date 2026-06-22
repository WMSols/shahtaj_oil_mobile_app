import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel(this.text, {super.key, this.accent = false});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: accent
          ? AppTextStyles.sectionTitleAccent(context)
          : AppTextStyles.sectionTitle(context),
    );
  }
}
