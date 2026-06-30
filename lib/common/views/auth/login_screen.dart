import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/auth/app_auth_primary_panel.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/auth/auth_header_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const AuthHeaderSection(), const AppAuthPrimaryPanel()],
        ),
      ),
    );
  }
}
