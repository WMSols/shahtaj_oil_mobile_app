import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_dropdown_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_section_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/shops/ob_shop_verify_on_site_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_missing_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_task_model.dart';

class ObShopVerifyOnSiteContent extends StatelessWidget {
  const ObShopVerifyOnSiteContent({
    super.key,
    required this.controller,
    required this.task,
  });

  final ObShopVerifyOnSiteController controller;
  final ObTaskModel task;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Touch shop type so CNIC required * rebuilds with cash/credit.
      final shopType = controller.selectedShopType.value;
      final isCnicRequired = controller.isCnicRequired;
      final isBusy =
          controller.isSubmitting.value || controller.isLocating.value;
      // Touch observables so Obx rebuilds when photos / fields change.
      final fields = controller.missingFields.toList(growable: false);
      final formFields = fields
          .where(
            (f) =>
                f.key == 'owner_cnic_number' ||
                f.key == 'owner_name' ||
                f.key == 'owner_phone' ||
                f.key == 'shop_category' ||
                (!f.isImage && !f.isGps),
          )
          .toList();
      formFields.sort((a, b) {
        if (a.key == 'shop_category') return -1;
        if (b.key == 'shop_category') return 1;
        return 0;
      });
      final imageFields = fields
          .where(
            (f) =>
                f.key == 'shop_exterior_photo' ||
                f.key == 'owner_photo' ||
                f.key == 'owner_cnic_front' ||
                f.key == 'owner_cnic_back' ||
                f.isImage,
          )
          .toList(growable: false);

      return Form(
        key: controller.formKey,
        child: ListView(
          padding: AppSpacing.screenPadding(context),
          children: [
            Text(
              task.shopName,
              style: AppTextStyles.sectionTitle(
                context,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
            if (task.ownerName != null) ...[
              AppSpacing.vertical(context, 0.006),
              Text(
                AppTexts.obShopOwner(task.ownerName!),
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.grey),
              ),
            ],
            AppSpacing.vertical(context, 0.01),
            Text(
              AppTexts.obShopVerifyOnSiteContext,
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(color: AppColors.grey),
            ),
            if (formFields.isNotEmpty) ...[
              AppSpacing.vertical(context, 0.02),
              AppFormSectionHeader(
                icon: AppIcons.person5,
                title: AppTexts.obSectionOwnerDetails,
              ),
              for (final field in formFields) ...[
                AppSpacing.vertical(context, 0.01),
                _buildFormField(
                  context,
                  field,
                  shopType: shopType,
                  isCnicRequired: isCnicRequired,
                ),
              ],
            ],
            if (imageFields.isNotEmpty) ...[
              AppSpacing.vertical(context, 0.02),
              AppFormSectionHeader(
                icon: AppIcons.cloudUpload5,
                title: AppTexts.obSectionDocumentsPhotos,
              ),
              AppSpacing.vertical(context, 0.01),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppSpacing.horizontalValue(context, 0.02),
                mainAxisSpacing: AppSpacing.verticalValue(context, 0.012),
                childAspectRatio: 1,
                children: [
                  for (final field in imageFields)
                    AppPhotoUploadTile(
                      title: field.key == 'shop_exterior_photo'
                          ? AppTexts.obShopExteriorTitle
                          : field.label,
                      required:
                          field.required || field.key == 'shop_exterior_photo',
                      subtitle: controller.photoSlot(field.key).value == null
                          ? controller.photoEmptyHint(field.key)
                          : AppTexts.obPhotoUploaded,
                      icon: controller.photoIcon(field.key),
                      imageBytes: controller.photoSlot(field.key).value,
                      onTap: isBusy
                          ? null
                          : () => controller.pickPhoto(field.key),
                    ),
                ],
              ),
            ],
            AppSpacing.vertical(context, 0.024),
            AppPrimaryButton(
              label: AppTexts.obTaskCheckIn,
              isLoading: isBusy,
              onPressed: isBusy ? null : controller.submit,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFormField(
    BuildContext context,
    ObShopMissingField field, {
    required ShopType? shopType,
    required bool isCnicRequired,
  }) {
    switch (field.key) {
      case 'owner_cnic_number':
        return AppTextField(
          key: ValueKey('verify-cnic-required-$isCnicRequired'),
          controller: controller.ownerCnicController,
          label: _labelWithoutAsterisk(field.label),
          hint: AppTexts.obOwnerCnicHint,
          prefixIcon: AppIcons.personalCard,
          required: isCnicRequired,
          borderless: true,
          keyboardType: TextInputType.number,
          inputFormatters: [PakistanCnicInputFormatter()],
          validator: controller.validateCnic,
          textInputAction: TextInputAction.next,
        );
      case 'owner_name':
        return AppTextField(
          controller: controller.ownerNameController,
          label: field.label,
          hint: AppTexts.obOwnerNameHint,
          prefixIcon: AppIcons.person,
          required: field.required,
          borderless: true,
          validator: (v) => controller.validateOptionalText(v, 'owner_name'),
          textInputAction: TextInputAction.next,
        );
      case 'owner_phone':
        return AppTextField(
          controller: controller.ownerPhoneController,
          label: field.label,
          hint: AppTexts.obOwnerPhoneHint,
          prefixIcon: AppIcons.phone,
          pakistanPhonePrefix: true,
          required: field.required,
          borderless: true,
          keyboardType: TextInputType.phone,
          inputFormatters: [PakistanPhoneInputFormatter()],
          validator: (v) => controller.validateOptionalText(v, 'owner_phone'),
          // Next control is often shop_category dropdown, not a text field.
          textInputAction: TextInputAction.done,
        );
      case 'shop_category':
        return AppDropdownField<ShopType>(
          fieldKey: ValueKey('verify-shop-type-$shopType'),
          label: field.label,
          hint: AppTexts.obShopTypeHint,
          prefixIcon: AppIcons.wallet,
          required: field.required,
          value: shopType,
          items: ShopType.values,
          getLabel: (type) => type.label,
          onChanged: controller.onShopTypeChanged,
          validator: field.required
              ? (value) => value == null ? AppTexts.fieldRequired : null
              : null,
        );
      case 'credit_limit':
        return AppTextField(
          controller: controller.creditLimitController,
          label: field.label.isNotEmpty
              ? field.label
              : AppTexts.obCreditLimitLabel,
          hint: AppTexts.obCreditLimitHint,
          prefixIcon: AppIcons.wallet,
          required: field.required,
          borderless: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) => controller.validateOptionalText(v, 'credit_limit'),
          textInputAction: TextInputAction.next,
        );
      case 'legacy_balance':
        return AppTextField(
          controller: controller.legacyBalanceController,
          label: field.label.isNotEmpty
              ? field.label
              : AppTexts.obLegacyBalanceLabel,
          hint: AppTexts.obLegacyBalanceHint,
          prefixIcon: AppIcons.wallet,
          required: field.required,
          borderless: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) =>
              controller.validateOptionalText(v, 'legacy_balance'),
          textInputAction: TextInputAction.next,
        );
      default:
        if (field.isImage || field.isGps) {
          return const SizedBox.shrink();
        }
        final isFloat = field.type == 'float' || field.type == 'number';
        return AppTextField(
          controller: controller.textControllerFor(field.key),
          label: field.label,
          hint: field.label,
          required: field.required,
          borderless: true,
          keyboardType: isFloat
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          validator: (v) => controller.validateOptionalText(v, field.key),
          textInputAction: TextInputAction.next,
        );
    }
  }

  static String _labelWithoutAsterisk(String label) {
    return label.replaceAll(RegExp(r'\s*\*+\s*$'), '').trim();
  }
}
