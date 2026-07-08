import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_dropdown_field.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_section_header.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_map_preview.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_shop_onboarding_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_route_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_zone_option.dart';

class ObRegisterShopForm extends StatelessWidget {
  const ObRegisterShopForm({super.key, required this.controller});

  final ObShopOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section(
            context,
            icon: AppIcons.shops5,
            title: AppTexts.obSectionShopInformation,
            children: [
              AppTextField(
                controller: controller.shopNameController,
                label: AppTexts.obShopNameLabel,
                hint: AppTexts.obShopNameHint,
                prefixIcon: AppIcons.shops,
                required: true,
                borderless: true,
                validator: controller.validateRequired,
                textInputAction: TextInputAction.next,
              ),
              AppSpacing.vertical(context, 0.01),
              Obx(
                () => AppDropdownField<ShopType>(
                  fieldKey: ValueKey(
                    'shop-type-${controller.selectedShopType.value}',
                  ),
                  label: AppTexts.obShopTypeLabel,
                  hint: AppTexts.obShopTypeHint,
                  prefixIcon: AppIcons.wallet,
                  required: true,
                  value: controller.selectedShopType.value,
                  items: ObShopOnboardingController.shopTypes,
                  getLabel: (type) => type.label,
                  onChanged: controller.onShopTypeChanged,
                  validator: controller.validateShopType,
                ),
              ),
            ],
          ),
          _section(
            context,
            icon: AppIcons.person5,
            title: AppTexts.obSectionOwnerDetails,
            children: [
              AppTextField(
                controller: controller.ownerNameController,
                label: AppTexts.obOwnerNameLabel,
                hint: AppTexts.obOwnerNameHint,
                prefixIcon: AppIcons.person,
                required: true,
                borderless: true,
                validator: controller.validateRequired,
                textInputAction: TextInputAction.next,
              ),
              AppSpacing.vertical(context, 0.01),
              Obx(
                () => AppTextField(
                  controller: controller.ownerCnicController,
                  label: AppTexts.obOwnerCnicLabel,
                  hint: AppTexts.obOwnerCnicHint,
                  prefixIcon: AppIcons.personalCard,
                  required: !controller.isEditing,
                  borderless: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [PakistanCnicInputFormatter()],
                  validator: controller.validateCnic,
                  textInputAction: TextInputAction.next,
                ),
              ),
              AppSpacing.vertical(context, 0.01),
              AppTextField(
                controller: controller.ownerPhoneController,
                label: AppTexts.obOwnerPhoneLabel,
                hint: AppTexts.obOwnerPhoneHint,
                prefixIcon: AppIcons.phone,
                pakistanPhonePrefix: true,
                required: true,
                borderless: true,
                keyboardType: TextInputType.phone,
                inputFormatters: [PakistanPhoneInputFormatter()],
                validator: controller.validatePhone,
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
          _section(
            context,
            icon: AppIcons.location5,
            title: AppTexts.obSectionLocation,
            children: [
              Obx(
                () => AppMapPreview(
                  latitude: controller.mapLatitude.value,
                  longitude: controller.mapLongitude.value,
                ),
              ),
              AppSpacing.vertical(context, 0.01),
              Text(
                controller.locationLabel,
                style: AppTextStyles.bodyText(context).copyWith(
                  color: controller.hasLocation
                      ? AppColors.textPrimary
                      : AppColors.grey,
                ),
              ),
              AppSpacing.vertical(context, 0.01),
              Obx(
                () => AppSecondaryButton(
                  label: AppTexts.obUseCurrentLocation,
                  icon: AppIcons.gps,
                  outlinedOnly: true,
                  isLoading: controller.isLocating.value,
                  onPressed: controller.isLocating.value
                      ? null
                      : controller.useCurrentLocation,
                ),
              ),
            ],
          ),
          Obx(
            () => _section(
              context,
              icon: AppIcons.routes5,
              title: AppTexts.obSectionRouteAssignment,
              children: [
                AppDropdownField<ObZoneOption>(
                  fieldKey: ValueKey('zone-${controller.zones.length}'),
                  label: AppTexts.obZoneLabel,
                  hint: AppTexts.obZoneHint,
                  prefixIcon: AppIcons.map,
                  value: controller.selectedZone.value,
                  items: controller.zones,
                  getLabel: (zone) => zone.name,
                  onChanged: controller.onZoneChanged,
                ),
                AppSpacing.vertical(context, 0.01),
                AppDropdownField<ObRouteOption>(
                  fieldKey: ValueKey(
                    'route-${controller.selectedZone.value?.id}-${controller.routes.length}',
                  ),
                  label: AppTexts.obRouteLabel,
                  hint: AppTexts.obRouteHint,
                  prefixIcon: AppIcons.routes,
                  value: controller.selectedRoute.value,
                  items: controller.routes,
                  getLabel: (route) => route.name,
                  onChanged: controller.routes.isEmpty
                      ? null
                      : controller.onRouteChanged,
                ),
              ],
            ),
          ),
          Obx(() {
            if (!controller.isCreditShop) {
              return const SizedBox.shrink();
            }

            return _section(
              context,
              icon: AppIcons.wallet5,
              title: AppTexts.obSectionCreditBalance,
              children: [
                AppTextField(
                  controller: controller.creditLimitController,
                  label: AppTexts.obCreditLimitLabel,
                  hint: AppTexts.obCreditLimitHint,
                  prefixIcon: AppIcons.wallet,
                  required: true,
                  borderless: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: controller.validateCreditLimit,
                  textInputAction: TextInputAction.next,
                ),
                AppSpacing.vertical(context, 0.01),
                AppTextField(
                  controller: controller.legacyBalanceController,
                  label: AppTexts.obLegacyBalanceLabel,
                  hint: AppTexts.obLegacyBalanceHint,
                  prefixIcon: AppIcons.wallet,
                  borderless: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: controller.validateOptionalAmount,
                  textInputAction: TextInputAction.next,
                ),
              ],
            );
          }),
          _section(
            context,
            icon: AppIcons.cloudUpload5,
            title: AppTexts.obSectionDocumentsPhotos,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppSpacing.horizontalValue(context, 0.02),
                mainAxisSpacing: AppSpacing.verticalValue(context, 0.012),
                childAspectRatio: 1,
                children: [
                  Obx(
                    () => AppPhotoUploadTile(
                      title: AppTexts.obCnicFrontTitle,
                      subtitle: controller.cnicFront.value == null
                          ? AppTexts.tapToUploadImages
                          : AppTexts.obPhotoUploaded,
                      icon: AppIcons.personalCard,
                      imageBytes: controller.cnicFront.value,
                      onTap: () =>
                          controller.pickPhoto(ShopPhotoSlot.cnicFront),
                    ),
                  ),
                  Obx(
                    () => AppPhotoUploadTile(
                      title: AppTexts.obCnicBackTitle,
                      subtitle: controller.cnicBack.value == null
                          ? AppTexts.tapToUploadImages
                          : AppTexts.obPhotoUploaded,
                      icon: AppIcons.personalCard,
                      imageBytes: controller.cnicBack.value,
                      onTap: () => controller.pickPhoto(ShopPhotoSlot.cnicBack),
                    ),
                  ),
                  Obx(
                    () => AppPhotoUploadTile(
                      title: AppTexts.obOwnerPhotoTitle,
                      subtitle: controller.ownerPhoto.value == null
                          ? AppTexts.obTakePortrait
                          : AppTexts.obPhotoUploaded,
                      icon: AppIcons.person,
                      imageBytes: controller.ownerPhoto.value,
                      onTap: () =>
                          controller.pickPhoto(ShopPhotoSlot.ownerPhoto),
                    ),
                  ),
                  Obx(
                    () => AppPhotoUploadTile(
                      title: AppTexts.obShopExteriorTitle,
                      subtitle: controller.shopExteriorPhoto.value == null
                          ? AppTexts.obCaptureShop
                          : AppTexts.obPhotoUploaded,
                      icon: AppIcons.cameraAdd,
                      imageBytes: controller.shopExteriorPhoto.value,
                      onTap: () =>
                          controller.pickPhoto(ShopPhotoSlot.shopExterior),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.verticalValue(context, 0.02)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFormSectionHeader(icon: icon, title: title),
          AppSpacing.vertical(context, 0.01),
          ...children,
        ],
      ),
    );
  }
}
