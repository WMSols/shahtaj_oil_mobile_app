import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/return/dm_return_stock_group.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/return/dm_return_controller.dart';

class DmReturnContent extends GetView<DmReturnController> {
  const DmReturnContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final model = controller.template.value;
      if (model == null) {
        return AppEmptyState(title: AppTexts.emptyNotFoundTitle);
      }

      if (controller.isEmptyReturn && !controller.isSubmitted) {
        return ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            AppEmptyState(
              title: AppTexts.dmNoActiveOrdersForReturn,
              subtitle: AppTexts.noDataYet,
            ),
          ],
        );
      }

      return ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          if (controller.isSubmitted)
            Padding(
              padding: EdgeInsets.only(
                bottom: AppSpacing.verticalValue(context, 0.012),
              ),
              child: Text(
                AppTexts.dmReturnAlreadySubmitted,
                style: AppTextStyles.bodyText(context).copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          DmReturnStockGroup(
            title: AppTexts.dmLeftoverStock,
            lines: model.leftover,
            statusColor: AppColors.primary,
            editable: !controller.isSubmitted,
            onQtyChanged: controller.updateLeftoverQty,
          ),
          AppTextField(
            hint: AppTexts.dmNotesHint,
            initialValue: controller.notes.value,
            minLines: 2,
            maxLines: 4,
            readOnly: controller.isSubmitted,
            textInputAction: TextInputAction.newline,
            onChanged: controller.isSubmitted
                ? null
                : controller.onNotesChanged,
          ),
          AppSpacing.vertical(context, 0.014),
          AppPrimaryButton(
            label: controller.isSubmitted
                ? AppTexts.dmReturnAlreadySubmitted
                : AppTexts.submit,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.isSubmitted ? null : controller.submitReturn,
          ),
        ],
      );
    });
  }
}
