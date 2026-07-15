import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_target_item_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_targets_service.dart';

class ObTargetsController extends GetxController with CachedLoadMixin {
  ObTargetsController(this._service);

  final ObTargetsService _service;

  final RxList<ObTargetItemModel> targets = <ObTargetItemModel>[].obs;

  @override
  bool get hasCachedData => targets.isNotEmpty;

  @override
  String get loadFailedMessage => AppTexts.error;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    targets.assignAll(await _service.fetchTargets());
  }
}
