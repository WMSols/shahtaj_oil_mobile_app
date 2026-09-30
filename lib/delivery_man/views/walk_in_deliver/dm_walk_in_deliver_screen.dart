import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/walk_in_deliver/dm_walk_in_deliver_controller.dart';

class DmWalkInDeliverScreen extends GetView<DmWalkInDeliverController> {
  const DmWalkInDeliverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.vanItems.isEmpty) {
          return AppShimmerSkeletons.genericList(context);
        }

        final items = controller.vanItems;

        return RefreshIndicator(
          onRefresh: () => controller.load(force: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.screenPadding(context),
            children: [
              Text(
                AppTexts.dmWalkInSubtitle,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.grey),
              ),
              AppSpacing.vertical(context, 0.016),
              AppTextField(
                controller: controller.customerNameController,
                label: AppTexts.dmCustomerNameLabel,
                hint: AppTexts.dmCustomerNameHint,
                required: true,
                textInputAction: TextInputAction.next,
              ),
              AppSpacing.vertical(context, 0.012),
              AppTextField(
                controller: controller.phoneController,
                label: AppTexts.dmCustomerPhoneLabel,
                hint: AppTexts.dmCustomerPhoneHint,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              AppSpacing.vertical(context, 0.02),
              AppSectionHeader(
                title: AppTexts.dmLinesLabel,
                bottomSpacing: true,
              ),
              if (items.isEmpty)
                AppEmptyState(title: AppTexts.dmWalkInNoStock)
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
                            '${(item.uom ?? '').isNotEmpty ? ' ${item.uom}' : ''}'
                            ' · ${AppTexts.dmQtyAvailableOnVan}: '
                            '${AppFormatter.targetAmount(item.qtyAvailable)}',
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
                required: true,
                textInputAction: TextInputAction.next,
              ),
              AppSpacing.vertical(context, 0.012),
              SizedBox(
                width: 160,
                child: AppPhotoUploadTile(
                  title: AppTexts.dmProofPhotoTitle,
                  subtitle: AppTexts.dmProofPhotoSubtitle,
                  icon: AppIcons.cameraAdd,
                  imageBytes: controller.proofPhotoBytes.value,
                  isUploading:
                      controller.isPickingPhoto.value ||
                      controller.isActing.value,
                  required: true,
                  onTap: controller.pickProofPhoto,
                ),
              ),
              AppSpacing.vertical(context, 0.016),
              Text(
                AppTexts.dmPaymentMethod,
                style: AppTextStyles.sectionTitle(context),
              ),
              AppSpacing.vertical(context, 0.008),
              Wrap(
                children: [
                  for (final option in DmWalkInDeliverController.paymentMethods)
                    AppFilterChip(
                      label: option.label,
                      selected: controller.method.value == option,
                      color: option.chipColor,
                      uppercase: false,
                      onTap: () => controller.setMethod(option),
                    ),
                ],
              ),
              if (controller.method.value == PaymentMethod.cheque) ...[
                AppSpacing.vertical(context, 0.012),
                AppTextField(
                  controller: controller.chequeNumberController,
                  label: AppTexts.dmChequeNumber,
                  hint: AppTexts.dmChequeNumberHint,
                  required: true,
                ),
                AppSpacing.vertical(context, 0.012),
                SizedBox(
                  width: 160,
                  child: AppPhotoUploadTile(
                    title: AppTexts.dmChequeImageTitle,
                    subtitle: AppTexts.dmChequeImageSubtitle,
                    icon: AppIcons.cameraAdd,
                    imageBytes: controller.chequeImageBytes.value,
                    isUploading:
                        controller.isPickingCheque.value ||
                        controller.isActing.value,
                    required: true,
                    onTap: controller.pickChequeImage,
                  ),
                ),
              ],
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
              AppSpacing.vertical(context, 0.04),
            ],
          ),
        );
      }),
    );
  }
}
