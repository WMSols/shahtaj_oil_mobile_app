import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/validator/app_validator.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_missing_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_verify_on_site_request.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/shops/ob_shop_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';

class ObShopVerifyOnSiteController extends GetxController {
  ObShopVerifyOnSiteController(this._taskService, this._shopService);

  final ObTaskService _taskService;
  final ObShopService _shopService;
  final formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final RxBool isLoading = true.obs;
  final RxBool isLocating = false.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<ObTaskModel> task = Rxn<ObTaskModel>();
  final missingFields = <ObShopMissingField>[].obs;

  final checkInLatitude = Rxn<double>();
  final checkInLongitude = Rxn<double>();

  final ownerCnicController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final creditLimitController = TextEditingController();
  final legacyBalanceController = TextEditingController();
  final _extraControllers = <String, TextEditingController>{};

  final shopExteriorPhoto = Rxn<Uint8List>();
  final ownerPhoto = Rxn<Uint8List>();
  final ownerCnicFront = Rxn<Uint8List>();
  final ownerCnicBack = Rxn<Uint8List>();
  final selectedShopType = Rxn<ShopType>();

  static const _gpsKeys = {'latitude', 'longitude'};

  static const _formKeys = {
    'owner_cnic_number',
    'owner_name',
    'owner_phone',
    'shop_category',
    'credit_limit',
    'legacy_balance',
  };

  static const _imageKeys = {
    'shop_exterior_photo',
    'owner_photo',
    'owner_cnic_front',
    'owner_cnic_back',
  };

  Map get _args => Get.arguments is Map ? Get.arguments as Map : const {};

  int? get taskId {
    final raw = _args['taskId'];
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '');
  }

  String? get shopId {
    final raw = _args['shopId'];
    if (raw == null) return null;
    return raw.toString();
  }

  bool get hasDeviceLocation {
    final lat = checkInLatitude.value;
    final lng = checkInLongitude.value;
    return lat != null && lng != null && lat.abs() <= 90 && lng.abs() <= 180;
  }

  bool get isCnicRequired => selectedShopType.value == ShopType.credit;

  void onShopTypeChanged(ShopType? type) {
    selectedShopType.value = type;
  }

  bool requiresKey(String key) =>
      missingFields.any((f) => f.key == key && f.required);

  bool showsKey(String key) => missingFields.any((f) => f.key == key);

  ObShopMissingField? fieldFor(String key) {
    for (final field in missingFields) {
      if (field.key == key) return field;
    }
    return null;
  }

  String labelFor(String key, String fallback) =>
      fieldFor(key)?.label.trim().isNotEmpty == true
      ? fieldFor(key)!.label
      : fallback;

  List<ObShopMissingField> get formFields => missingFields
      .where((f) => _formKeys.contains(f.key) || (!f.isImage && !f.isGps))
      .toList(growable: false);

  List<ObShopMissingField> get imageFields => missingFields
      .where((f) => _imageKeys.contains(f.key) || f.isImage)
      .toList(growable: false);

  bool get hasFormFields => formFields.isNotEmpty;
  bool get hasImageFields => imageFields.isNotEmpty;

  Rxn<Uint8List> photoSlot(String key) => switch (key) {
    'shop_exterior_photo' => shopExteriorPhoto,
    'owner_photo' => ownerPhoto,
    'owner_cnic_front' => ownerCnicFront,
    'owner_cnic_back' => ownerCnicBack,
    _ => shopExteriorPhoto,
  };

  IconData photoIcon(String key) => switch (key) {
    'shop_exterior_photo' => AppIcons.shops,
    'owner_photo' => AppIcons.person,
    'owner_cnic_front' || 'owner_cnic_back' => AppIcons.personalCard,
    _ => AppIcons.cameraAdd,
  };

  String photoEmptyHint(String key) => switch (key) {
    'shop_exterior_photo' => AppTexts.obCaptureShop,
    'owner_photo' => AppTexts.obTakePortrait,
    _ => AppTexts.tapToUploadImages,
  };

  @override
  void onInit() {
    super.onInit();
    final lat = _args['latitude'];
    final lng = _args['longitude'];
    if (lat is num) checkInLatitude.value = lat.toDouble();
    if (lng is num) checkInLongitude.value = lng.toDouble();
    _load();
  }

  @override
  void onClose() {
    ownerCnicController.dispose();
    ownerNameController.dispose();
    ownerPhoneController.dispose();
    creditLimitController.dispose();
    legacyBalanceController.dispose();
    for (final c in _extraControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  TextEditingController textControllerFor(String key) {
    switch (key) {
      case 'owner_cnic_number':
        return ownerCnicController;
      case 'owner_name':
        return ownerNameController;
      case 'owner_phone':
        return ownerPhoneController;
      case 'credit_limit':
        return creditLimitController;
      case 'legacy_balance':
        return legacyBalanceController;
      default:
        return _extraControllers.putIfAbsent(key, TextEditingController.new);
    }
  }

  double? _parseOptionalDouble(String text) {
    final cleaned = text.trim().replaceAll(',', '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      final taskFromArgs = _taskFromArgs();
      ObTaskModel? resolved;
      final id = taskId ?? taskFromArgs?.id;
      if (id != null) {
        resolved = await _taskService.findTaskById(id, forceRefresh: true);
      }
      if (resolved == null && shopId != null && shopId!.isNotEmpty) {
        resolved = await _taskService.findTaskByShopId(
          shopId!,
          forceRefresh: true,
        );
      }
      resolved ??= taskFromArgs;
      task.value = resolved;
      selectedShopType.value ??=
          resolved?.shopType ?? _resolveInitialShopType();

      final parsed = <ObShopMissingField>[];
      if (resolved != null && resolved.missingFields.isNotEmpty) {
        parsed.addAll(resolved.missingFields);
      } else {
        final fromArgs = _args['missingFields'];
        if (fromArgs is List && fromArgs.isNotEmpty) {
          for (final item in fromArgs.whereType<Map>()) {
            parsed.add(
              ObShopMissingField.fromJson(Map<String, dynamic>.from(item)),
            );
          }
        }
      }

      // Keep every empty field from API (required + optional); GPS stays silent.
      final byKey = <String, ObShopMissingField>{
        for (final f in parsed)
          if (f.key.isNotEmpty && !_gpsKeys.contains(f.key)) f.key: f,
      };

      final needsSetup =
          resolved?.needsShopSetup ?? taskFromArgs?.needsShopSetup;
      if (byKey.isEmpty && needsSetup == true) {
        for (final f in _defaultMissingFields) {
          byKey[f.key] = f;
        }
      }

      missingFields.assignAll(byKey.values.toList(growable: false));

      if (resolved?.ownerCnicNumber != null &&
          resolved!.ownerCnicNumber!.trim().isNotEmpty &&
          showsKey('owner_cnic_number')) {
        ownerCnicController.text = resolved.ownerCnicNumber!;
      }
      if (resolved?.ownerName != null && showsKey('owner_name')) {
        ownerNameController.text = resolved!.ownerName!;
      }
      if (resolved?.phone != null && showsKey('owner_phone')) {
        ownerPhoneController.text = resolved!.phone!;
      }
    } finally {
      isLoading.value = false;
    }
  }

  ObTaskModel? _taskFromArgs() {
    final raw = _args['task'];
    if (raw is Map) {
      return ObTaskModel.fromJson(Map<String, dynamic>.from(raw));
    }
    final id = taskId;
    final sid = shopId;
    final name = _args['shopName']?.toString();
    if (id == null || sid == null) return null;
    return ObTaskModel(
      id: id,
      shopId: sid,
      shopName: (name == null || name.isEmpty) ? 'Shop' : name,
      sequence: 0,
      ownerName: _args['ownerName']?.toString(),
      ownerCnicNumber: _args['ownerCnicNumber']?.toString(),
      phone: _args['phone']?.toString(),
      needsShopSetup: true,
    );
  }

  ShopType? _resolveInitialShopType() {
    final fromArgs =
        _parseShopTypeValue(_args['shopCategory']) ??
        _parseShopTypeValue(_args['shop_category']);
    if (fromArgs != null) return fromArgs;

    final rawTask = _args['task'];
    if (rawTask is Map) {
      final taskMap = Map<String, dynamic>.from(rawTask);
      final fromTask =
          _parseShopTypeValue(taskMap['shop_category']) ??
          _parseShopTypeValue(taskMap['shopCategory']);
      if (fromTask != null) return fromTask;

      final shop = taskMap['shop'];
      if (shop is Map) {
        final shopMap = Map<String, dynamic>.from(shop);
        return _parseShopTypeValue(shopMap['shop_category']);
      }
    }
    return null;
  }

  ShopType? _parseShopTypeValue(dynamic raw) {
    if (raw == null) return null;
    if (raw is ShopType) return raw;
    final normalized = raw.toString().trim().toLowerCase();
    if (normalized == ShopType.cash.name) return ShopType.cash;
    if (normalized == ShopType.credit.name) return ShopType.credit;
    return null;
  }

  Future<bool> _captureDeviceLocationSilently() async {
    isLocating.value = true;
    try {
      final position = await AppHelper.requireCurrentPosition(showGuide: true);
      checkInLatitude.value = position.latitude;
      checkInLongitude.value = position.longitude;
      return true;
    } on ApiException catch (e) {
      _showMessage(e.message);
      return false;
    } catch (_) {
      _showMessage(AppTexts.obLocationFetchFailed);
      return false;
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> pickPhoto(String key) async {
    // Not-visited flow: capture GPS when shop exterior photo is tapped.
    if (key == 'shop_exterior_photo') {
      final captured = await _captureDeviceLocationSilently();
      if (!captured) return;
    }

    final source = key == 'owner_cnic_front' || key == 'owner_cnic_back'
        ? await _pickImageSource()
        : ImageSource.camera;
    if (source == null) return;

    final file = await _picker.pickImage(source: source, imageQuality: 90);
    if (file == null) return;
    final raw = await file.readAsBytes();
    final bytes = await AppImageCompress.compress(raw);

    switch (key) {
      case 'shop_exterior_photo':
        shopExteriorPhoto.value = bytes;
      case 'owner_photo':
        ownerPhoto.value = bytes;
      case 'owner_cnic_front':
        ownerCnicFront.value = bytes;
      case 'owner_cnic_back':
        ownerCnicBack.value = bytes;
    }
  }

  Future<ImageSource?> _pickImageSource() async {
    return Get.bottomSheet<ImageSource>(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              title: Text(AppTexts.obPickFromCamera),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              title: Text(AppTexts.obPickFromGallery),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  String? validateCnic(String? value) {
    if (!showsKey('owner_cnic_number')) return null;
    final empty = value == null || value.trim().isEmpty;
    if (empty) return isCnicRequired ? AppTexts.fieldRequired : null;
    return AppValidator.validatePakistanCnic(value);
  }

  String? validateOptionalText(String? value, String key) {
    if (!showsKey(key)) return null;
    if (requiresKey(key) && (value == null || value.trim().isEmpty)) {
      return AppTexts.fieldRequired;
    }
    if (key == 'owner_phone' && value != null && value.trim().isNotEmpty) {
      return AppValidator.validatePakistanLocalPhone(value);
    }
    return null;
  }

  Future<void> submit() async {
    final current = task.value;
    if (current == null) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      AppToast.showError(AppTexts.formInvalid);
      return;
    }

    // GPS is captured when shop exterior photo is tapped; fallback if missing.
    if (!hasDeviceLocation) {
      final captured = await _captureDeviceLocationSilently();
      if (!captured || !hasDeviceLocation) return;
    }

    for (final field in imageFields) {
      final bytes = photoSlot(field.key).value;
      if (field.required && bytes == null) {
        _showMessage(
          field.key == 'shop_exterior_photo'
              ? AppTexts.obShopExteriorRequired
              : AppTexts.obPhotoRequired,
        );
        return;
      }
    }

    if (showsKey('shop_category') &&
        requiresKey('shop_category') &&
        selectedShopType.value == null) {
      _showMessage(AppTexts.fieldRequired);
      return;
    }

    final exteriorBytes = shopExteriorPhoto.value;
    // verify-on-site API always requires exterior photo.
    if (exteriorBytes == null) {
      _showMessage(AppTexts.obShopExteriorRequired);
      return;
    }

    final shopIdInt = int.tryParse(current.shopId);
    if (shopIdInt == null) {
      _showMessage(AppTexts.error);
      return;
    }

    isSubmitting.value = true;
    try {
      final result = await _shopService.verifyOnSite(
        ObShopVerifyOnSiteRequest(
          shopId: shopIdInt,
          taskId: current.id,
          latitude: checkInLatitude.value!,
          longitude: checkInLongitude.value!,
          shopExteriorPhoto: base64Encode(exteriorBytes),
          ownerCnicNumber: showsKey('owner_cnic_number')
              ? ownerCnicController.text.trim()
              : null,
          ownerPhoto: ownerPhoto.value == null
              ? null
              : base64Encode(ownerPhoto.value!),
          ownerCnicFront: ownerCnicFront.value == null
              ? null
              : base64Encode(ownerCnicFront.value!),
          ownerCnicBack: ownerCnicBack.value == null
              ? null
              : base64Encode(ownerCnicBack.value!),
          ownerName: showsKey('owner_name')
              ? ownerNameController.text.trim()
              : null,
          ownerPhone: showsKey('owner_phone')
              ? ownerPhoneController.text.trim()
              : null,
          shopCategory: showsKey('shop_category')
              ? selectedShopType.value?.name
              : null,
          creditLimit: showsKey('credit_limit')
              ? _parseOptionalDouble(creditLimitController.text)
              : null,
          legacyBalance: showsKey('legacy_balance')
              ? _parseOptionalDouble(legacyBalanceController.text)
              : null,
        ),
      );

      if (result.hasVisit) {
        await _taskService.applyActiveVisit(result.visit!);
        _showMessage(
          result.message ?? AppTexts.obShopVerifiedSuccess,
          isError: false,
        );
        Get.offNamed(
          AppRoutes.obOrderCreate,
          arguments: {'visitId': result.visit!.visitId},
        );
        return;
      }

      _showMessage(result.message ?? AppTexts.error);
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    if (isError) {
      AppToast.showError(message);
    } else {
      AppToast.showSuccess(message);
    }
  }

  /// Fallback when API does not send `missing_fields` — show all fillable empties.
  static const _defaultMissingFields = <ObShopMissingField>[
    ObShopMissingField(
      key: 'shop_exterior_photo',
      label: 'Shop Exterior / PFA License Number',
      required: true,
      type: 'image',
      source: 'camera',
    ),
    ObShopMissingField(
      key: 'owner_cnic_number',
      label: 'Owner CNIC Number',
      required: false,
      type: 'string',
      source: 'form',
    ),
    ObShopMissingField(
      key: 'owner_photo',
      label: 'Owner Photo',
      required: false,
      type: 'image',
      source: 'camera',
    ),
    ObShopMissingField(
      key: 'owner_cnic_front',
      label: 'CNIC Front',
      required: false,
      type: 'image',
      source: 'camera',
    ),
    ObShopMissingField(
      key: 'owner_cnic_back',
      label: 'CNIC Back',
      required: false,
      type: 'image',
      source: 'camera',
    ),
    ObShopMissingField(
      key: 'owner_name',
      label: 'Owner Name',
      required: false,
      type: 'string',
      source: 'form',
    ),
    ObShopMissingField(
      key: 'owner_phone',
      label: 'Owner Phone',
      required: false,
      type: 'string',
      source: 'form',
    ),
    ObShopMissingField(
      key: 'shop_category',
      label: 'Shop Category',
      required: false,
      type: 'string',
      source: 'form',
    ),
    ObShopMissingField(
      key: 'credit_limit',
      label: 'Credit Limit',
      required: false,
      type: 'float',
      source: 'form',
    ),
    ObShopMissingField(
      key: 'legacy_balance',
      label: 'Legacy Balance',
      required: false,
      type: 'float',
      source: 'form',
    ),
  ];
}
