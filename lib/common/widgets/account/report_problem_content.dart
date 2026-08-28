import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/account/report_problem_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/models/account/report_problem_kind.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_field_label.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';

class ReportProblemContent extends GetView<ReportProblemController> {
  const ReportProblemContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          AppFormFieldLabel(
            label: AppTexts.reportProblemWhatWrong,
            required: true,
          ),
          Wrap(
            runSpacing: AppSpacing.verticalValue(context, 0.008),
            children: [
              for (final kind in controller.chips)
                AppFilterChip(
                  label: kind.label,
                  selected: controller.selectedKind.value == kind,
                  uppercase: false,
                  onTap: () => controller.selectKind(kind),
                ),
            ],
          ),
          AppSpacing.vertical(context, 0.02),
          AppTextField(
            hint: AppTexts.reportProblemDetailsHint,
            minLines: 3,
            maxLines: 6,
            textInputAction: TextInputAction.newline,
            onChanged: controller.onDetailsChanged,
          ),
          AppSpacing.vertical(context, 0.02),
          AppPrimaryButton(
            label: AppTexts.submit,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.canSubmit ? controller.submit : null,
          ),
        ],
      );
    });
  }
}
