import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/sync/sync_center_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';

class SyncCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SyncCenterController(Get.find<SyncOutboxService>()));
  }
}
