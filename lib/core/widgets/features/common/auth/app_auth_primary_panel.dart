import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shahtaj_oil_mobile_app/common/controllers/auth_controller.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_remember_me.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_brought_by_footer.dart';

class AppAuthPrimaryPanel extends GetView<AuthController> {
  const AppAuthPrimaryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context, factor: 6);

    return Expanded(
      child: Container(
        width: double.infinity,
        padding: AppSpacing.screenPadding(
          context,
        ).copyWith(top: AppSpacing.verticalValue(context, 0.04)),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: controller.emailController,
                        prefixIcon: AppIcons.email,
                        label: AppTexts.email,
                        hint: AppTexts.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        labelColor: AppColors.white,
                        textColor: AppColors.textPrimary,
                        hintColor: AppColors.textMuted,
                        fillColor: AppColors.white,
                        borderColor: AppColors.cardBorder,
                        focusedBorderColor: AppColors.white,
                      ),
                      AppSpacing.vertical(context, 0.02),
                      Obx(
                        () => AppTextField(
                          controller: controller.passwordController,
                          prefixIcon: AppIcons.lock,
                          label: AppTexts.password,
                          hint: AppTexts.passwordHint,
                          obscureText: controller.obscurePassword.value,
                          textInputAction: TextInputAction.done,
                          suffixIcon: controller.obscurePassword.value
                              ? AppIcons.eyeSlash
                              : AppIcons.eye,
                          onSuffixTap: controller.togglePasswordVisibility,
                          onSubmitted: (_) => controller.login(),
                          labelColor: AppColors.white,
                          textColor: AppColors.textPrimary,
                          hintColor: AppColors.textMuted,
                          fillColor: AppColors.white,
                          borderColor: AppColors.cardBorder,
                          focusedBorderColor: AppColors.white,
                        ),
                      ),
                      AppSpacing.vertical(context, 0.012),
                      Obx(
                        () => AppRememberMe(
                          value: controller.rememberMe.value,
                          onChanged: controller.setRememberMe,
                        ),
                      ),
                      AppSpacing.vertical(context, 0.02),
                      Obx(
                        () => AppSecondaryButton(
                          label: AppTexts.signInButton,
                          isLoading: controller.isLoading.value,
                          onPressed: controller.login,
                        ),
                      ),
                      AppSpacing.vertical(context, 0.01),
                      Obx(
                        () => AppSecondaryButton(
                          label: AppTexts.switchRole,
                          outlinedOnly: true,
                          textColor: AppColors.white,
                          borderColor: AppColors.white,
                          onPressed: controller.isLoading.value
                              ? null
                              : () => Get.offAllNamed(AppRoutes.selectRole),
                        ),
                      ),
                      const Spacer(),
                      AppBroughtByFooter(
                        textColor: AppColors.white.withValues(alpha: 0.75),
                        accentColor: AppColors.white,
                        dividerColor: AppColors.white.withValues(alpha: 0.25),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
