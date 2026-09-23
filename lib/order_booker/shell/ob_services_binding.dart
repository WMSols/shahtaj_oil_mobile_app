import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/local_media_store.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/shops/ob_shop_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/sync/ob_day_bootstrap_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_cart_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_session_service.dart';

/// Keeps visit/task state alive across pushed routes (check-in, order create).
class OrderBookerServicesBinding {
  OrderBookerServicesBinding._();

  static void ensureRegistered() {
    // Visit sessions come first: task and cart services both read local visits.
    if (!Get.isRegistered<ObVisitSessionService>()) {
      Get.put<ObVisitSessionService>(
        ObVisitSessionService(
          Get.find<AppDatabase>(),
          Get.find<SyncOutboxService>(),
          Get.find<LocalMediaStore>(),
        ),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ObTaskService>()) {
      Get.put<ObTaskService>(
        ObTaskService(Get.find<ApiClient>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ObVisitCartService>()) {
      Get.put<ObVisitCartService>(
        ObVisitCartService(
          Get.find<ApiClient>(),
          Get.find<AppDatabase>(),
          Get.find<SyncOutboxService>(),
        ),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ObShopService>()) {
      Get.put<ObShopService>(
        ObShopService(Get.find<ApiClient>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ObDayBootstrapService>()) {
      Get.put<ObDayBootstrapService>(
        ObDayBootstrapService(Get.find<ApiClient>(), Get.find<AppDatabase>()),
        permanent: true,
      );
    }
  }
}
