import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class LocaleService extends GetxService {
  LocaleService(this._storage);

  final StorageService _storage;

  static const Locale english = Locale('en', 'US');
  static const Locale urdu = Locale('ur', 'PK');

  final Rx<Locale> locale = english.obs;

  bool get isRtl => locale.value.languageCode == 'ur';

  Future<LocaleService> init() async {
    final code = await _storage.getLocale();
    if (code == 'ur') {
      locale.value = urdu;
      Get.updateLocale(urdu);
    } else {
      locale.value = english;
      Get.updateLocale(english);
    }
    return this;
  }

  Future<void> setEnglish() => _apply(english);

  Future<void> setUrdu() => _apply(urdu);

  Future<void> toggleLocale() =>
      locale.value == english ? setUrdu() : setEnglish();

  Future<void> _apply(Locale value) async {
    locale.value = value;
    await _storage.saveLocale(value.languageCode);
    Get.updateLocale(value);
  }
}
