import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class OnboardingController extends GetxController {
  static const pageCount = 3;

  static const illustrations = [
    AppImages.onboardingIntro,
    AppImages.onboardingLanguage,
    AppImages.onboardingRole,
  ];

  static String titleFor(int index) => switch (index) {
    0 => AppTexts.onboardingIntroTitle,
    1 => AppTexts.onboardingLanguageTitle,
    _ => AppTexts.onboardingRoleTitle,
  };

  static String bodyFor(int index) => switch (index) {
    0 => AppTexts.onboardingIntroBody,
    1 => AppTexts.onboardingLanguageBody,
    _ => AppTexts.onboardingRoleBody,
  };

  final LocaleService _locale = Get.find<LocaleService>();
  final StorageService _storage = Get.find<StorageService>();

  late final PageController pageController;
  final RxInt currentPage = 0.obs;
  final RxBool isEnglishSelected = true.obs;
  final Rxn<UserRole> selectedRole = Rxn<UserRole>();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    isEnglishSelected.value =
        _locale.locale.value.languageCode != LocaleService.urdu.languageCode;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) => currentPage.value = index;

  Future<void> goToNextPage() async {
    if (currentPage.value >= pageCount - 1) return;
    await pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> selectEnglish() async {
    isEnglishSelected.value = true;
    await _locale.setEnglish();
  }

  Future<void> selectUrdu() async {
    isEnglishSelected.value = false;
    await _locale.setUrdu();
  }

  Future<void> selectRole(UserRole role) async {
    selectedRole.value = role;
    await _storage.saveRole(role.name);
    await _storage.setOnboardingCompleted();
    Get.offAllNamed(AppRoutes.login, arguments: role);
  }
}
