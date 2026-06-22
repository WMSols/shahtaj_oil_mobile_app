import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';

/// Placeholder screen for module views until full UI is implemented.
class AppModulePlaceholder extends StatelessWidget {
  const AppModulePlaceholder({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: AppEmptyState(
          title: title,
          subtitle: AppTexts.comingSoon,
        ),
      ),
    );
  }
}
