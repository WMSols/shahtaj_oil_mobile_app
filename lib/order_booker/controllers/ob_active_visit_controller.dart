import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';

class ObActiveVisitController extends GetxController {
  ObActiveVisitController(this._taskService);

  final ObTaskService _taskService;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<ObActiveVisitModel> activeVisit = Rxn<ObActiveVisitModel>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      activeVisit.value = await _taskService.fetchActiveVisit();
    } catch (_) {
      error.value = AppTexts.error;
      activeVisit.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void resumeVisit() {
    final visit = activeVisit.value;
    if (visit == null) return;
    Get.toNamed(
      AppRoutes.obOrderCreate,
      arguments: {'shopId': visit.shopId, 'taskId': visit.taskId},
    );
  }
}
