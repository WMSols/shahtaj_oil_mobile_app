import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/reports/report_create_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_field_label.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';

class ReportCreateScreen extends GetView<ReportCreateController> {
  const ReportCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.reportCreateTitle,
      body: Obx(() {
        return ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            AppTextField(
              label: AppTexts.reportSubjectLabel,
              hint: AppTexts.reportSubjectHint,
              required: true,
              onChanged: controller.onSubjectChanged,
            ),
            AppSpacing.vertical(context, 0.015),
            AppTextField(
              label: AppTexts.reportDescriptionLabel,
              hint: AppTexts.reportDescriptionHint,
              required: true,
              minLines: 4,
              maxLines: 8,
              textInputAction: TextInputAction.newline,
              onChanged: controller.onDescriptionChanged,
            ),
            AppSpacing.vertical(context, 0.02),
            AppFormFieldLabel(label: AppTexts.reportTagsLabel, required: true),
            if (controller.isLoadingTags.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.tags.isEmpty)
              Text(
                AppTexts.emptyLoadFailedSubtitle,
                style: AppTextStyles.hintText(context),
              )
            else
              Wrap(
                runSpacing: AppSpacing.verticalValue(context, 0.006),
                children: [
                  for (final tag in controller.tags)
                    AppFilterChip(
                      label: tag.name,
                      selected: controller.selectedCodes.contains(tag.code),
                      uppercase: false,
                      onTap: () => controller.toggleTag(tag),
                    ),
                ],
              ),
            AppSpacing.vertical(context, 0.02),
            AppFormFieldLabel(label: AppTexts.reportScreenshotLabel),
            AppSpacing.vertical(context, 0.008),
            GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.horizontalValue(context, 0.02),
              mainAxisSpacing: AppSpacing.verticalValue(context, 0.012),
              childAspectRatio: 2,
              children: [
                AppPhotoUploadTile(
                  title: AppTexts.reportScreenshotLabel,
                  subtitle: controller.screenshotBytes.value == null
                      ? AppTexts.tapToUploadImages
                      : AppTexts.obPhotoUploaded,
                  icon: AppIcons.cameraOutlined,
                  imageBytes: controller.screenshotBytes.value,
                  isUploading: controller.isSubmitting.value,
                  onTap: controller.pickScreenshot,
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.025),
            AppPrimaryButton(
              label: AppTexts.submit,
              isLoading: controller.isSubmitting.value,
              onPressed: controller.submit,
            ),
          ],
        );
      }),
    );
  }
}
