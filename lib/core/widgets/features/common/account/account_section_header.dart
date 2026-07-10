import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';

class AccountSectionHeader extends StatelessWidget {
  const AccountSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.verticalValue(context, 0.01)),
      child: Text(title, style: AppTextStyles.sectionTitle(context)),
    );
  }
}
