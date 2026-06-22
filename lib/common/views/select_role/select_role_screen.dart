import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/select_role_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';

class SelectRoleScreen extends GetView<SelectRoleController> {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: AppSpacing.screenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppTexts.selectYourRole,
              style: AppTextStyles.headline(context),
            ),
            AppSpacing.vertical(context, 0.03),
            ...UserRole.values.map(
              (role) => Obx(
                () => ListTile(
                  title: Text(
                    role.label,
                    style: AppTextStyles.bodyText(context),
                  ),
                  leading: Icon(
                    controller.selectedRole.value == role
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: controller.selectedRole.value == role
                        ? AppColors.primary
                        : AppColors.grey,
                  ),
                  onTap: () => controller.selectRole(role),
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => AppPrimaryButton(
                label: AppTexts.next,
                onPressed: controller.selectedRole.value == null
                    ? null
                    : controller.continueToOnboarding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
