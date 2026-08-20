import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';

/// Keeps RM store alive across shell leaves and pushed routes.
/// [ensureRegistered] is idempotent — safe to call from every controller.
class RecoveryManServicesBinding {
  RecoveryManServicesBinding._();

  static void ensureRegistered() {
    if (!Get.isRegistered<RmCollectionStore>()) {
      final store = Get.put<RmCollectionStore>(
        RmCollectionStore(),
        permanent: true,
      );
      // Kick off cache hydration; controllers await their own load which
      // implicitly triggers seedIfEmpty as a synchronous fallback if needed.
      store.hydrate();
    }
  }
}
