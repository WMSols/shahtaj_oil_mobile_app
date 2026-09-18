import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/free_deliver/dm_free_deliver_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/load/dm_load_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/sync/dm_day_bootstrap_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';

/// Keeps DM services alive across shell leaves and pushed routes.
/// [ensureRegistered] is idempotent — safe to call from every controller.
class DmServicesBinding {
  DmServicesBinding._();

  static void ensureRegistered() {
    if (!Get.isRegistered<DmSessionService>()) {
      Get.put(DmSessionService(Get.find<ApiClient>()), permanent: true);
    }
    if (!Get.isRegistered<DmLoadService>()) {
      Get.put(DmLoadService(Get.find<ApiClient>()), permanent: true);
    }
    if (!Get.isRegistered<DmVanService>()) {
      Get.put(DmVanService(Get.find<ApiClient>()), permanent: true);
    }
    if (!Get.isRegistered<DmPlanService>()) {
      Get.put(DmPlanService(Get.find<ApiClient>()), permanent: true);
    }
    if (!Get.isRegistered<DmFreeDeliverService>()) {
      Get.put(
        DmFreeDeliverService(Get.find<ApiClient>(), Get.find<DmVanService>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<DmDayBootstrapService>()) {
      Get.put(DmDayBootstrapService(), permanent: true);
    }
    if (!Get.isRegistered<DmRecoveryService>()) {
      Get.put(DmRecoveryService(Get.find<ApiClient>()), permanent: true);
    }
    if (!Get.isRegistered<DmCollectionStore>()) {
      final store = Get.put<DmCollectionStore>(
        DmCollectionStore(),
        permanent: true,
      );
      store.hydrate();
    }
  }
}
