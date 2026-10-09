import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_shop_closed_controller.dart';

class DmShopClosedScreen extends GetView<DmShopClosedController> {
  const DmShopClosedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmShopClosedTitle,
      body: Obx(() {
        return ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            if (controller.shopName.isNotEmpty) ...[
              Text(
                controller.shopName,
                style: AppTextStyles.sectionTitle(context),
              ),
              AppSpacing.vertical(context, 0.008),
            ],
            Text(
              AppTexts.dmShopClosedSubtitle,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.grey),
            ),
            AppSpacing.vertical(context, 0.02),
            AppTextField(
              controller: controller.notesController,
              label: AppTexts.dmShopClosedNotesLabel,
              hint: AppTexts.dmShopClosedNotesHint,
              required: true,
              minLines: 3,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
            ),
            AppSpacing.vertical(context, 0.02),
            SizedBox(
              width: 160,
              child: AppPhotoUploadTile(
                title: AppTexts.dmShopClosedPhotoTitle,
                subtitle: AppTexts.dmShopClosedPhotoSubtitle,
                icon: AppIcons.cameraAdd,
                imageBytes: controller.photoBytes.value,
                isUploading:
                    controller.isPickingPhoto.value ||
                    controller.isActing.value,
                required: true,
                onTap: controller.pickPhoto,
              ),
            ),
            AppSpacing.vertical(context, 0.03),
            AppPrimaryButton(
              label: AppTexts.dmShopClosedTitle,
              isLoading: controller.isActing.value,
              onPressed: controller.submit,
              backgroundColor: AppColors.error,
            ),
          ],
        );
      }),
    );
  }
}
