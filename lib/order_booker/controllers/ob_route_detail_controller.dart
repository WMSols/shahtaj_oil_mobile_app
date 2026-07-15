import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_today_tasks_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';

class ObRouteDetailController extends GetxController {
  ObRouteDetailController(this._taskService);

  final ObTaskService _taskService;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<ObTodayTasksModel> todayTasks = Rxn<ObTodayTasksModel>();
  final Rxn<ObActiveVisitModel> activeVisit = Rxn<ObActiveVisitModel>();

  String get routeId => Get.parameters['id'] ?? '';

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks({bool silent = false, bool force = false}) async {
    final hasCache = todayTasks.value != null;
    if (!force && hasCache && !silent) {
      isLoading.value = false;
      return;
    }

    if (!silent && !hasCache) {
      isLoading.value = true;
    }
    try {
      final data = await _taskService.fetchTodayTasks();
      todayTasks.value = data;
      activeVisit.value = await _taskService.fetchActiveVisit();

      if (routeId.isNotEmpty &&
          data.route.status == RouteStatus.notStarted &&
          data.route.id == routeId) {
        await _taskService.startRoute(routeId);
        todayTasks.value = await _taskService.fetchTodayTasks();
      }
      error.value = null;
    } catch (_) {
      if (!hasCache) {
        error.value = AppTexts.error;
      }
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
  }

  void openCheckIn(ObTaskModel task) {
    final active = activeVisit.value;
    if (active != null &&
        active.taskId != task.id &&
        active.shopId != task.shopId) {
      AppToast.showError(AppTexts.obShopVisitActiveElsewhere);
      return;
    }

    final nav = Get.toNamed(
      AppRoutes.obCheckIn,
      arguments: {'taskId': task.id},
    );
    nav?.then((_) => loadTasks(force: true));
  }

  Future<void> confirmSkipTask(ObTaskModel task) async {
    final confirmed = await Get.dialog<bool>(
      AppConfirmDialog(
        title: AppTexts.obSkipTaskTitle,
        message: AppTexts.obSkipTaskMessage,
        confirmLabel: AppTexts.obTaskSkip,
      ),
    );
    if (confirmed != true) return;

    try {
      await _taskService.skipTask(task.id);
      await loadTasks(force: true);
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage(AppTexts.error);
    }
  }

  void openTaskNotes(ObTaskModel task) {
    Get.toNamed(
      AppRoutes.obNotes,
      arguments: {
        'purpose': ObNotesPurpose.taskNotes,
        'taskId': task.id,
        'initialNotes': task.notes,
      },
    );
  }

  void resumeActiveVisit() {
    final visit = activeVisit.value;
    if (visit == null) return;
    Get.toNamed(AppRoutes.obOrderCreate, arguments: {'visitId': visit.visitId});
  }

  void _showMessage(String message) {
    AppToast.showError(message);
  }
}
