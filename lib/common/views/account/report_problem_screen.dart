import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/common/widgets/account/report_problem_content.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';

class ReportProblemScreen extends StatelessWidget {
  const ReportProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.reportProblemTitle,
      body: const ReportProblemContent(),
    );
  }
}
