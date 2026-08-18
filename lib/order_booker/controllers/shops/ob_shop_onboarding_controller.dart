import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/order_booker/shell/order_booker_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/validator/app_validator.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/shops/ob_my_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_route_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_register_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_zone_option.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/shops/ob_shop_service.dart';

enum ShopPhotoSlot { cnicFront, cnicBack, ownerPhoto, shopExterior }

class ObShopOnboardingController extends GetxController {
  ObShopOnboardingController(this._shopService);

  final ObShopService _shopService;
  final formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerCnicController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final creditLimitController = TextEditingController();
  final legacyBalanceController = TextEditingController();

  final zones = <ObZoneOption>[].obs;
  final routes = <ObRouteOption>[].obs;
  final selectedZone = Rxn<ObZoneOption>();
  final selectedRoute = Rxn<ObRouteOption>();
  final selectedShopType = Rxn<ShopType>();

  final mapLatitude = Rxn<double>();
  final mapLongitude = Rxn<double>();

  final cnicFront = Rxn<Uint8List>();
  final cnicBack = Rxn<Uint8List>();
  final ownerPhoto = Rxn<Uint8List>();
  final shopExteriorPhoto = Rxn<Uint8List>();

  final isLoadingOptions = true.obs;
  final isSubmitting = false.obs;
  final isLocating = false.obs;
  final RxnString loadError = RxnString();

  /// Bumped on clear so Form / dropdowns fully remount with empty state.
  final formEpoch = 0.obs;

  bool get isCreditShop => selectedShopType.value == ShopType.credit;

  bool get hasLocation {
    final lat = mapLatitude.value;
    final lng = mapLongitude.value;
    return lat != null && lng != null && lat.abs() <= 90 && lng.abs() <= 180;
  }

  String get locationLabel => hasLocation
      ? AppFormatter.coordinates(mapLatitude.value!, mapLongitude.value!)
      : AppTexts.obLocationNotCaptured;

  String get screenTitle => AppTexts.obShopOnboardingTitle;

  String get submitLabel => AppTexts.obRegisterShopButton;

  static const shopTypes = ShopType.values;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  @override
  void onClose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    ownerCnicController.dispose();
    ownerPhoneController.dispose();
    creditLimitController.dispose();
    legacyBalanceController.dispose();
    super.onClose();
  }

  Future<void> _bootstrap({bool forceLookups = false}) async {
    isLoadingOptions.value = true;
    loadError.value = null;
    try {
      zones.assignAll(await _shopService.fetchZones(force: forceLookups));
    } catch (_) {
      loadError.value = AppTexts.error;
    } finally {
      isLoadingOptions.value = false;
    }
  }

  Future<void> onZoneChanged(ObZoneOption? zone) async {
    selectedZone.value = zone;
    selectedRoute.value = null;
    routes.clear();
    if (zone == null) return;
    routes.assignAll(await _shopService.fetchRoutes(zoneId: zone.id));
    if (routes.isEmpty) {
      AppToast.showWarning(AppTexts.obNoRoutesInZone);
    }
  }

  void onRouteChanged(ObRouteOption? route) => selectedRoute.value = route;

  void onShopTypeChanged(ShopType? type) {
    selectedShopType.value = type;
    if (type != ShopType.credit) {
      creditLimitController.clear();
      legacyBalanceController.clear();
    }
  }

  String? validateShopType(ShopType? value) {
    if (value == null) return AppTexts.fieldRequired;
    return null;
  }

  String? validateZone(ObZoneOption? value) {
    if (value == null) return AppTexts.fieldRequired;
    return null;
  }

  String? validateRoute(ObRouteOption? value) {
    if (selectedZone.value != null && routes.isEmpty) {
      return AppTexts.obNoRoutesInZone;
    }
    if (value == null) return AppTexts.fieldRequired;
    return null;
  }

  String? validateCreditLimit(String? value) {
    if (!isCreditShop) return null;
    if (value == null || value.trim().isEmpty) return AppTexts.fieldRequired;
    return validateOptionalAmount(value);
  }

  void _setLocation(double latitude, double longitude) {
    mapLatitude.value = latitude;
    mapLongitude.value = longitude;
  }

  Uint8List? photoFor(ShopPhotoSlot slot) => switch (slot) {
    ShopPhotoSlot.cnicFront => cnicFront.value,
    ShopPhotoSlot.cnicBack => cnicBack.value,
    ShopPhotoSlot.ownerPhoto => ownerPhoto.value,
    ShopPhotoSlot.shopExterior => shopExteriorPhoto.value,
  };

  Future<void> pickPhoto(ShopPhotoSlot slot) async {
    final source = switch (slot) {
      ShopPhotoSlot.cnicFront ||
      ShopPhotoSlot.cnicBack => await _pickCnicImageSource(),
      _ => ImageSource.camera,
    };
    if (source == null) return;

    final file = await _picker.pickImage(source: source, imageQuality: 90);
    if (file == null) return;

    final raw = await file.readAsBytes();
    final bytes = await AppImageCompress.compress(raw);
    switch (slot) {
      case ShopPhotoSlot.cnicFront:
        cnicFront.value = bytes;
      case ShopPhotoSlot.cnicBack:
        cnicBack.value = bytes;
      case ShopPhotoSlot.ownerPhoto:
        ownerPhoto.value = bytes;
      case ShopPhotoSlot.shopExterior:
        shopExteriorPhoto.value = bytes;
    }
  }

  Future<ImageSource?> _pickCnicImageSource() async {
    return Get.bottomSheet<ImageSource>(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(AppIcons.cameraOutlined),
              title: Text(AppTexts.obPickFromCamera),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(AppIcons.photoLibraryOutlined),
              title: Text(AppTexts.obPickFromGallery),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> useCurrentLocation() async {
    isLocating.value = true;
    try {
      final position = await AppHelper.requireCurrentPosition();
      _setLocation(position.latitude, position.longitude);
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage(AppTexts.obLocationFetchFailed);
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      AppToast.showError(AppTexts.formInvalid);
      return;
    }
    if (!hasLocation) {
      _showMessage(AppTexts.obLocationNotCaptured);
      return;
    }
    if (shopExteriorPhoto.value == null) {
      _showMessage(AppTexts.obShopExteriorRequired);
      return;
    }
    if (selectedZone.value == null) {
      _showMessage(AppTexts.fieldRequired);
      return;
    }
    if (routes.isEmpty) {
      _showMessage(AppTexts.obNoRoutesInZone);
      return;
    }
    if (selectedRoute.value == null) {
      _showMessage(AppTexts.fieldRequired);
      return;
    }

    isSubmitting.value = true;
    try {
      await _submitRegister();
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _submitRegister() async {
    final request = ObShopRegisterRequest(
      name: shopNameController.text.trim(),
      ownerName: ownerNameController.text.trim(),
      ownerCnic: _normalizedCnic(),
      ownerPhone: _normalizedPhone(),
      latitude: mapLatitude.value!,
      longitude: mapLongitude.value!,
      shopType: selectedShopType.value!,
      zoneId: selectedZone.value?.id,
      routeId: selectedRoute.value?.id,
      creditLimit: isCreditShop
          ? _parseOptionalDouble(creditLimitController.text)
          : null,
      legacyBalance: isCreditShop
          ? _parseOptionalDouble(legacyBalanceController.text)
          : null,
      ownerCnicFront: _encodePhoto(cnicFront.value),
      ownerCnicBack: _encodePhoto(cnicBack.value),
      ownerPhoto: _encodePhoto(ownerPhoto.value),
      shopExteriorPhoto: _encodePhoto(shopExteriorPhoto.value),
    );

    final shop = await _shopService.registerShop(request);
    clearForm();
    _showMessage(AppTexts.obShopRegisteredSuccess, isError: false);

    if (Get.isRegistered<ObMyShopsController>()) {
      final myShops = Get.find<ObMyShopsController>();
      await myShops.loadShops(force: true);
      // shops/mine can lag or return empty right after register; keep the
      // submitted shop visible from the register response.
      myShops.upsertShop(shop);
    }

    _navigateToMyShops();
  }

  void _navigateToMyShops() {
    if (Get.currentRoute == AppRoutes.obShopOnboarding) {
      Get.back(result: true);
      return;
    }
    if (Get.isRegistered<OrderBookerShellController>()) {
      Get.find<OrderBookerShellController>().selectLeaf('ob_my_shops');
    }
  }

  void showHelp() {
    Get.dialog(
      AlertDialog(
        title: Text(AppTexts.obRegisterShopHelpTitle),
        content: Text(AppTexts.obRegisterShopHelpBody),
        actions: [TextButton(onPressed: Get.back, child: Text(AppTexts.done))],
      ),
    );
  }

  Future<void> onPullToRefresh() async {
    final confirmed = await Get.dialog<bool>(
      AppConfirmDialog(
        title: AppTexts.obRegisterShopResetTitle,
        message: AppTexts.obRegisterShopResetMessage,
      ),
    );

    if (confirmed == true) {
      clearForm();
      zones.assignAll(await _shopService.fetchZones(force: true));
    }
  }

  void clearForm() {
    shopNameController.clear();
    ownerNameController.clear();
    ownerCnicController.clear();
    ownerPhoneController.clear();
    creditLimitController.clear();
    legacyBalanceController.clear();

    selectedZone.value = null;
    selectedRoute.value = null;
    selectedShopType.value = null;
    routes.clear();

    mapLatitude.value = null;
    mapLongitude.value = null;

    cnicFront.value = null;
    cnicBack.value = null;
    ownerPhoto.value = null;
    shopExteriorPhoto.value = null;

    // Do not call FormState.reset() — it restores initial field values and
    // undoes TextEditingController.clear() for shop name / type.
    formEpoch.value++;
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return AppTexts.fieldRequired;
    return null;
  }

  String? validatePhone(String? value) =>
      AppValidator.validatePakistanLocalPhone(value);

  String? validateCnic(String? value) {
    final empty = value == null || value.trim().isEmpty;
    if (empty) {
      return isCreditShop ? AppTexts.fieldRequired : null;
    }
    return AppValidator.validatePakistanCnic(value);
  }

  String? validateOptionalAmount(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.replaceAll(',', '').trim();
    if (double.tryParse(normalized) == null) return AppTexts.amountInvalid;
    return null;
  }

  String _normalizedCnic() {
    final digits = ownerCnicController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 13) return digits;
    return '${digits.substring(0, 5)}-'
        '${digits.substring(5, 12)}-'
        '${digits.substring(12)}';
  }

  String _normalizedPhone() {
    final digits = ownerPhoneController.text.replaceAll(RegExp(r'\D'), '');
    final local = digits.startsWith('92') ? digits.substring(2) : digits;
    return '+92$local';
  }

  double? _parseOptionalDouble(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  String? _encodePhoto(Uint8List? bytes) =>
      bytes == null ? null : base64Encode(bytes);

  void _showMessage(String message, {bool isError = true}) {
    if (isError) {
      AppToast.showError(message);
    } else {
      AppToast.showSuccess(message);
    }
  }
}
