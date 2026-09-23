import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/free_deliver/dm_free_deliver_controller.dart';

class DmFreeDeliverScreen extends GetView<DmFreeDeliverController> {
  const DmFreeDeliverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmFreeDeliverTitle,
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppShimmerSkeletons.genericList(context);
        }

        final shop = controller.shop.value;
        if (shop == null) {
          return AppEmptyState(title: AppTexts.dmFreeDeliverEmpty);
        }

        final items = controller.vanItems;

        return ListView(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          children: [
            AppOutlineCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  AppDetailRow(
                    label: AppTexts.dmShopNameLabel,
                    value: shop.name.isEmpty ? shop.shopId : shop.name,
                    showDivider: shop.address != null,
                  ),
                  if (shop.address != null)
                    AppDetailRow(
                      label: AppTexts.dmAddressLabel,
                      value: shop.address!,
                      showDivider: false,
                    ),
                ],
              ),
            ),
            AppSpacing.vertical(context, 0.016),
            Text(
              AppTexts.dmLinesLabel,
              style: AppTextStyles.sectionTitle(context),
            ),
            AppSpacing.vertical(context, 0.01),
            if (items.isEmpty)
              AppEmptyState(title: AppTexts.dmFreeDeliverNoStock)
            else
              ...items.map((item) {
                final draft = controller.qtyDrafts[item.productId] ?? '';
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: AppSpacing.verticalValue(context, 0.01),
                  ),
                  child: AppOutlineCard(
                    padding: AppSpacing.all(context, factor: 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: AppTextStyles.sectionTitle(context),
                        ),
                        AppSpacing.vertical(context, 0.006),
                        Text(
                          '${AppTexts.dmQtyOnVan}: '
                          '${AppFormatter.targetAmount(item.qtyOnVan)}'
                          '${(item.uom ?? '').isNotEmpty ? ' ${item.uom}' : ''}',
                          style: AppTextStyles.caption(
                            context,
                          ).copyWith(color: AppColors.grey),
                        ),
                        AppSpacing.vertical(context, 0.01),
                        AppTextField(
                          label: AppTexts.dmQtyDeliver,
                          hint: '0',
                          initialValue: draft,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          onChanged: (v) =>
                              controller.onQtyChanged(item.productId, v),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            AppSpacing.vertical(context, 0.016),
            AppTextField(
              controller: controller.receiverController,
              label: AppTexts.dmReceiverNameLabel,
              hint: AppTexts.dmReceiverNameHint,
            ),
            AppSpacing.vertical(context, 0.012),
            SizedBox(
              width: 160,
              child: AppPhotoUploadTile(
                title: AppTexts.dmProofPhotoTitle,
                subtitle: AppTexts.dmProofPhotoSubtitle,
                icon: AppIcons.cameraAdd,
                imageBytes: controller.proofPhotoBytes.value,
                isUploading: controller.isActing.value,
                onTap: controller.pickProofPhoto,
              ),
            ),
            AppSpacing.vertical(context, 0.016),
            AppTextField(
              controller: controller.notesController,
              label: AppTexts.dmNotesLabel,
              hint: AppTexts.dmNotesHint,
              maxLines: 3,
            ),
            AppSpacing.vertical(context, 0.016),
            AppPrimaryButton(
              label: AppTexts.dmConfirmDelivery,
              isLoading: controller.isActing.value,
              onPressed: items.isEmpty ? null : controller.submit,
            ),
          ],
        );
      }),
    );
  }
}
