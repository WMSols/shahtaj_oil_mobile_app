import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';

/// Keeps the collection store alive across shell leaves and pushed routes.
/// [ensureRegistered] is idempotent — safe to call from every controller.
class DmServicesBinding {
  DmServicesBinding._();

  static void ensureRegistered() {
    if (!Get.isRegistered<DmCollectionStore>()) {
      final store = Get.put<DmCollectionStore>(
        DmCollectionStore(),
        permanent: true,
      );
      // Kick off cache hydration; controllers await their own load which
      // implicitly triggers seedIfEmpty as a synchronous fallback if needed.
      store.hydrate();
    }
  }
}
