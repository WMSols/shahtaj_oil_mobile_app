import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_amount_summary_bar.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_dropdown_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_section_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_confirm_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/handover/rm_bag_snapshot_strip.dart';

class RmHandoverConfirmContent extends GetView<RmHandoverConfirmController> {
  const RmHandoverConfirmContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && !controller.hasCachedData) {
        return AppShimmerSkeletons.genericList(context, count: 4);
      }

      if (controller.error.value != null && !controller.hasCachedData) {
        return AppEmptyState(
          title: AppTexts.emptyLoadFailedTitle,
          subtitle: controller.error.value!,
          image: AppImages.emptyError,
          onRefresh: () => controller.loadBag(force: true),
        );
      }

      if (controller.receiptCount.value <= 0) {
        return AppEmptyState(
          title: AppTexts.emptyNoHandoverTitle,
          subtitle: AppTexts.rmBagEmpty,
          image: AppImages.emptyNoHandover,
        );
      }

      return Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSpacing.screenPadding(context),
              children: [
                RmBagSnapshotStrip(
                  cashInBag: controller.cashInBag.value,
                  chequeInBag: controller.chequeInBag.value,
                  bagTotal: controller.bagTotal.value,
                ),
                AppSpacing.vertical(context, 0.02),
                AppFormSectionHeader(
                  icon: AppIcons.wallet,
                  title: AppTexts.rmCountedCash,
                  required: true,
                ),
                AppSpacing.vertical(context, 0.012),
                AppTextField(
                  controller: controller.countedCashController,
                  hint: AppTexts.rmCountedCashHint,
                  required: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                ),
                AppSpacing.vertical(context, 0.02),
                AppFormSectionHeader(
                  icon: AppIcons.person,
                  title: AppTexts.rmCashierName,
                  required: true,
                ),
                AppSpacing.vertical(context, 0.012),
                AppDropdownField<String>(
                  fieldKey: ValueKey(
                    controller.selectedManager.value ?? 'rm_manager',
                  ),
                  hint: AppTexts.rmCashierNameHint,
                  required: true,
                  prefixIcon: AppIcons.person,
                  value: controller.selectedManager.value,
                  items: controller.managers.toList(growable: false),
                  onChanged: controller.selectManager,
                ),
                AppSpacing.vertical(context, 0.02),
                AppFormSectionHeader(
                  icon: AppIcons.history,
                  title: AppTexts.rmHandoverNotes,
                ),
                AppSpacing.vertical(context, 0.012),
                AppTextField(
                  controller: controller.notesController,
                  hint: AppTexts.rmHandoverNotesHint,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                AppSpacing.vertical(context, 0.12),
              ],
            ),
          ),
          Material(
            color: AppColors.white,
            elevation: 8,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: AppSpacing.screenPadding(context).copyWith(
                  top: AppSpacing.verticalValue(context, 0.012),
                  bottom: AppSpacing.verticalValue(context, 0.012),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAmountSummaryBar(
                      label: AppTexts.rmBagTotal,
                      amount: controller.bagTotal.value,
                    ),
                    AppSpacing.vertical(context, 0.012),
                    AppPrimaryButton(
                      label: AppTexts.rmConfirmHandover,
                      isLoading: controller.isSaving.value,
                      onPressed: controller.submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
