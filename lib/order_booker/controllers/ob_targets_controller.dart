import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_target_item_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_targets_service.dart';

class ObTargetsController extends GetxController {
  ObTargetsController(this._service);

  final ObTargetsService _service;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final RxList<ObTargetItemModel> targets = <ObTargetItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      targets.assignAll(await _service.fetchTargets());
    } catch (_) {
      error.value = AppTexts.error;
      targets.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
