import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';

/// Keeps DM services alive across shell leaves and pushed routes.
/// [ensureRegistered] is idempotent — safe to call from every controller.
class DmServicesBinding {
  DmServicesBinding._();

  static void ensureRegistered() {
    if (!Get.isRegistered<DmSessionService>()) {
      Get.put(DmSessionService(Get.find<ApiClient>()), permanent: true);
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
