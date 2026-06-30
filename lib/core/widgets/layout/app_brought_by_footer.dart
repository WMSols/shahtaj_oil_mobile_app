import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class AppBroughtByFooter extends StatelessWidget {
  const AppBroughtByFooter({
    super.key,
    this.textColor,
    this.accentColor,
    this.showDivider = false,
    this.dividerColor,
  });

  final Color? textColor;
  final Color? accentColor;
  final bool showDivider;
  final Color? dividerColor;
  static final Uri _developerWebsite = Uri.parse('https://wmsols.com/');

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.caption(context).copyWith(color: textColor);
    final accentStyle = baseStyle.copyWith(
      color: accentColor ?? textColor,
      fontWeight: FontWeight.w600,
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDivider) ...[
            Divider(
              color: dividerColor ?? textColor?.withValues(alpha: 0.3),
              height: 1,
            ),
            AppSpacing.vertical(context, 0.01),
          ],
          Text.rich(
            TextSpan(
              style: baseStyle,
              children: [
                TextSpan(text: AppTexts.broughtByPrefix),
                TextSpan(
                  text: AppTexts.developerName,
                  style: accentStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrl(
                      _developerWebsite,
                      mode: LaunchMode.externalApplication,
                    ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
