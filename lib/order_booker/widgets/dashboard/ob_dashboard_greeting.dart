import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_dashboard_greeting.dart';

class ObDashboardGreeting extends StatelessWidget {
  const ObDashboardGreeting({
    super.key,
    required this.greeting,
    required this.userName,
  });

  final String greeting;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return AppDashboardGreeting(
      greeting: greeting,
      userName: userName,
      subtitle: AppTexts.obDashboardSubtitle,
    );
  }
}
