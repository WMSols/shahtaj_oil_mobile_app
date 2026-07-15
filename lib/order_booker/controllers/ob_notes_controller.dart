import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/order_booker_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_route_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_cart_service.dart';

class ObNotesController extends GetxController {
  ObNotesController(this._taskService, this._cartService);

  final ObTaskService _taskService;
  final ObVisitCartService _cartService;

  final isSaving = false.obs;
  late final TextEditingController notesController;

  late final ObNotesPurpose purpose;
  int? taskId;
  int? visitId;

  Map<String, dynamic> get _args => Get.arguments is Map
      ? Map<String, dynamic>.from(Get.arguments as Map)
      : {};

  String get title => switch (purpose) {
    ObNotesPurpose.taskNotes => AppTexts.obTaskNotes,
    ObNotesPurpose.endVisitWithoutOrder => AppTexts.obEndVisitTitle,
    ObNotesPurpose.visitNotes => AppTexts.obSaveVisitNotes,
  };

  String get hint => switch (purpose) {
    ObNotesPurpose.taskNotes => AppTexts.obTaskNotesHint,
    ObNotesPurpose.endVisitWithoutOrder => AppTexts.obEndVisitNotesHint,
    ObNotesPurpose.visitNotes => AppTexts.obVisitNotesHint,
  };

  String get confirmLabel => switch (purpose) {
    ObNotesPurpose.endVisitWithoutOrder => AppTexts.confirm,
    ObNotesPurpose.taskNotes || ObNotesPurpose.visitNotes => AppTexts.save,
  };

  bool get notesRequired => purpose == ObNotesPurpose.endVisitWithoutOrder;

  @override
  void onInit() {
    super.onInit();
    final args = _args;
    purpose = args['purpose'] as ObNotesPurpose? ?? ObNotesPurpose.taskNotes;
    taskId = args['taskId'] as int?;
    visitId = args['visitId'] as int?;
    notesController = TextEditingController(
      text: args['initialNotes'] as String? ?? '',
    );
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  Future<void> save() async {
    final notes = notesController.text.trim();
    if (notesRequired && notes.isEmpty) return;

    isSaving.value = true;
    try {
      switch (purpose) {
        case ObNotesPurpose.taskNotes:
          await _saveTaskNotes(notes);
        case ObNotesPurpose.endVisitWithoutOrder:
          await _endVisitWithoutOrder(notes);
          return;
        case ObNotesPurpose.visitNotes:
          await _saveVisitNotes(notes);
      }
      if (!isClosed) Get.back();
    } on ApiException catch (e) {
      if (!isClosed) {
        isSaving.value = false;
        AppToast.showError(e.message);
      }
    } catch (_) {
      if (!isClosed) {
        isSaving.value = false;
        AppToast.showError(AppTexts.error);
      }
    }
  }

  Future<void> _saveTaskNotes(String notes) async {
    final id = taskId;
    if (id == null) return;
    await _taskService.saveTaskNotes(taskId: id, notes: notes);
    if (Get.isRegistered<ObRouteDetailController>()) {
      await Get.find<ObRouteDetailController>().loadTasks(
        silent: true,
        force: true,
      );
    }
  }

  Future<void> _endVisitWithoutOrder(String notes) async {
    final id = visitId;
    if (id == null) {
      if (!isClosed) isSaving.value = false;
      return;
    }
    await _cartService.endWithoutOrder(visitId: id, notes: notes);
    await _taskService.clearActiveVisit(visitId: id);
    AppToast.showSuccess(AppTexts.obVisitClosedSuccess);
    Get.offAllNamed(AppRoutes.orderBooker);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<OrderBookerShellController>()) {
        Get.find<OrderBookerShellController>().selectLeaf('ob_today_tasks');
      }
      if (Get.isRegistered<ObRouteDetailController>()) {
        Get.find<ObRouteDetailController>().loadTasks(force: true);
      }
    });
  }

  Future<void> _saveVisitNotes(String notes) async {
    final id = visitId;
    if (id == null) return;
    await _cartService.saveVisitNotes(visitId: id, notes: notes);
    AppToast.showSuccess(AppTexts.save);
  }
}
