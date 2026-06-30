import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/select_role_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/common/select_role/select_role_option_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_brought_by_footer.dart';

class SelectRoleScreen extends GetView<SelectRoleController> {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.selectYourRole,
                style: AppTextStyles.headline(context),
              ),
              AppSpacing.vertical(context, 0.015),
              Text(
                AppTexts.selectRoleBody,
                style: AppTextStyles.bodyText(context),
              ),
              AppSpacing.vertical(context, 0.03),
              Expanded(
                child: Obx(() {
                  final selected = controller.selectedRole.value;
                  return ListView.separated(
                    itemCount: UserRole.values.length,
                    separatorBuilder: (_, _) =>
                        AppSpacing.vertical(context, 0.015),
                    itemBuilder: (context, index) {
                      final role = UserRole.values[index];
                      return SelectRoleOptionCard(
                        title: role.label,
                        subtitle: role.subtitle,
                        imageAsset: role.imageAsset,
                        selected: selected == role,
                        onTap: () => controller.selectRole(role),
                      );
                    },
                  );
                }),
              ),
              AppSpacing.vertical(context, 0.02),
              Obx(
                () => AppPrimaryButton(
                  label: AppTexts.continueLabel,
                  onPressed: controller.selectedRole.value == null
                      ? null
                      : controller.continueToLogin,
                ),
              ),
              AppSpacing.vertical(context, 0.02),
              AppBroughtByFooter(
                textColor: AppColors.textMuted,
                accentColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
