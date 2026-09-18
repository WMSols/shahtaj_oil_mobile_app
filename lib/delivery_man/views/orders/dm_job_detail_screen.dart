import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_job_detail_controller.dart';

String _fmt(double value) => value == value.roundToDouble()
    ? '${value.toInt()}'
    : value.toStringAsFixed(1);

class DmJobDetailScreen extends GetView<DmJobDetailController> {
  const DmJobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmJobDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppShimmerSkeletons.genericList(context);
        }
        final job = controller.job.value;
        if (job == null) {
          return AppEmptyState(title: AppTexts.dmJobNotFound);
        }

        return ListView(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          children: [
            AppOutlineCard(
              statusColor: job.fieldState.chipColor,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  AppDetailRow(
                    label: AppTexts.dmShopNameLabel,
                    value: job.shopName,
                    showDivider: true,
                  ),
                  if (job.orderName != null)
                    AppDetailRow(
                      label: AppTexts.dmOrderIdLabel,
                      value: job.orderName!,
                    ),
                  AppDetailRow(
                    label: AppTexts.dmJobIdLabel,
                    value: '${job.jobId}',
                  ),
                  AppDetailRow(
                    label: AppTexts.dmFieldStateLabel,
                    trailing: AppStatusChip(
                      label: job.fieldState.label,
                      color: job.fieldState.chipColor,
                    ),
                  ),
                  AppDetailRow(
                    label: AppTexts.dmJobStateLabel,
                    trailing: AppStatusChip(
                      label: job.state.label,
                      color: job.state.chipColor,
                      soft: true,
                    ),
                    showDivider: job.shopAddress != null,
                  ),
                  if (job.shopAddress != null)
                    AppDetailRow(
                      label: AppTexts.dmAddressLabel,
                      value: job.shopAddress!,
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
            if (job.lines.isEmpty)
              AppEmptyState(title: AppTexts.dmNoJobLines)
            else
              ...job.lines.map((line) {
                final draft = controller.qtyDrafts[line.lineId] ?? '';
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
                          line.name,
                          style: AppTextStyles.sectionTitle(context),
                        ),
                        AppSpacing.vertical(context, 0.006),
                        Text(
                          '${AppTexts.dmQtyAssigned}: ${_fmt(line.qtyAssigned)}'
                          ' · ${AppTexts.dmQtyPicked}: ${_fmt(line.qtyPicked)}'
                          ' · ${AppTexts.dmQtyStill}: ${_fmt(line.qtyStill)}',
                          style: AppTextStyles.caption(
                            context,
                          ).copyWith(color: AppColors.grey),
                        ),
                        if (controller.canActOnField) ...[
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
                                controller.onQtyChanged(line.lineId, v),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            AppSpacing.vertical(context, 0.016),
            if (controller.canDeliver) ...[
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
                  onTap: controller.pickProofPhoto,
                ),
              ),
              AppSpacing.vertical(context, 0.016),
            ],
            AppTextField(
              controller: controller.notesController,
              label: AppTexts.dmNotesLabel,
              hint: AppTexts.dmNotesHint,
              maxLines: 3,
            ),
            AppSpacing.vertical(context, 0.016),
            if (controller.canDeliver)
              AppPrimaryButton(
                label: AppTexts.dmConfirmDelivery,
                isLoading: controller.isActing.value,
                onPressed: controller.submitDeliver,
              ),
            if (!controller.canDeliver &&
                (job.receiverName ?? '').isNotEmpty) ...[
              AppDetailRow(
                label: AppTexts.dmReceiverNameLabel,
                value: job.receiverName!,
              ),
              if (job.hasDeliveryProof)
                AppDetailRow(
                  label: AppTexts.dmProofPhotoTitle,
                  value: AppTexts.dmDeliveryProofCaptured,
                  showDivider: false,
                ),
              AppSpacing.vertical(context, 0.016),
            ],
            if (controller.canActOnField) ...[
              AppSpacing.vertical(context, 0.01),
              AppSecondaryButton(
                label: AppTexts.dmShopClosedTitle,
                isLoading: controller.isActing.value,
                onPressed: controller.submitShopClosed,
              ),
              AppSpacing.vertical(context, 0.01),
              AppSecondaryButton(
                label: AppTexts.dmFailedTitle,
                isLoading: controller.isActing.value,
                onPressed: controller.submitFailed,
              ),
              AppSpacing.vertical(context, 0.01),
              AppSecondaryButton(
                label: AppTexts.dmReturnUndeliveredTitle,
                isLoading: controller.isActing.value,
                onPressed: controller.submitReturnUndelivered,
              ),
            ],
            AppSpacing.vertical(context, 0.01),
            AppSecondaryButton(
              label: AppTexts.dmRecoverAtShop,
              onPressed: () {
                final shopId = job.shopId;
                if (shopId.isEmpty) return;
                Get.toNamed(
                  AppRoutes.dmShopOutstanding.replaceFirst(':id', shopId),
                  arguments: {'shopId': shopId},
                );
              },
            ),
            AppSpacing.vertical(context, 0.01),
            AppSecondaryButton(
              label: AppTexts.dmSaveNotes,
              isLoading: controller.isActing.value,
              onPressed: controller.saveNotes,
            ),
          ],
        );
      }),
    );
  }
}
