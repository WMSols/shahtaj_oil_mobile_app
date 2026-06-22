import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/auth_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: AppSpacing.screenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppTexts.authWelcomeTitle,
              style: AppTextStyles.headline(context),
            ),
            AppSpacing.vertical(context, 0.01),
            Text(
              AppTexts.authWelcomeSubtitle,
              style: AppTextStyles.bodyText(context),
            ),
            AppSpacing.vertical(context, 0.03),
            AppTextField(
              controller: controller.emailController,
              label: AppTexts.email,
              hint: AppTexts.emailHint,
            ),
            AppSpacing.vertical(context, 0.02),
            AppTextField(
              controller: controller.passwordController,
              label: AppTexts.password,
              hint: AppTexts.passwordHint,
              obscureText: true,
            ),
            const Spacer(),
            Obx(
              () => AppPrimaryButton(
                label: AppTexts.signInButton,
                isLoading: controller.isLoading.value,
                onPressed: controller.login,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
