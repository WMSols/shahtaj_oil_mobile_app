import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/rm_targets_model.dart';

class RmDashboardController extends GetxController {
  final RxBool isLoading = true.obs;

  RmTargetsModel get targets => AppMockData.rmTargets;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
  }
}
