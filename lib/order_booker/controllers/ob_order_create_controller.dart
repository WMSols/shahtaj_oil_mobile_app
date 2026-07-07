import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/order_booker_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/tasks/ob_task_notes_sheet.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_route_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_product_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_cart_service.dart';

class ObOrderCreateController extends GetxController {
  ObOrderCreateController(this._taskService, this._cartService);

  final ObTaskService _taskService;
  final ObVisitCartService _cartService;

  final RxBool isLoading = true.obs;
  final RxBool isPlacingOrder = false.obs;
  final RxnString error = RxnString();
  final Rxn<ObActiveVisitModel> activeVisit = Rxn<ObActiveVisitModel>();
  final RxList<ObProductModel> products = <ObProductModel>[].obs;
  final Rxn<ObVisitCartModel> cart = Rxn<ObVisitCartModel>();

  int? get visitId =>
      Get.arguments is Map ? (Get.arguments as Map)['visitId'] as int? : null;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      final fallback = await _taskService.fetchActiveVisit();
      final active = fallback;
      final resolvedVisitId = visitId ?? active?.visitId;
      if (active == null || resolvedVisitId == null) {
        error.value = AppTexts.obActiveVisitMissing;
        return;
      }
      activeVisit.value = active;
      await _loadProductsAndCart(active, resolvedVisitId);
    } catch (_) {
      error.value = AppTexts.error;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadProductsAndCart(ObActiveVisitModel active, int id) async {
    products.assignAll(await _cartService.fetchProducts(visitId: id));
    cart.value = await _cartService.fetchCart(
      visitId: id,
      shopName: active.shopName,
    );
  }

  Future<void> addProduct(ObProductModel product) async {
    final active = activeVisit.value;
    if (active == null) return;
    await _cartService.addLine(visitId: active.visitId, productId: product.id);
    await _reloadCart();
  }

  Future<void> updateQuantity(int lineId, double quantity) async {
    final active = activeVisit.value;
    if (active == null) return;
    await _cartService.updateLine(
      visitId: active.visitId,
      lineId: lineId,
      quantity: quantity <= 0 ? 1 : quantity,
    );
    await _reloadCart();
  }

  Future<void> removeLine(int lineId) async {
    final active = activeVisit.value;
    if (active == null) return;
    await _cartService.removeLine(visitId: active.visitId, lineId: lineId);
    await _reloadCart();
  }

  Future<void> promptPlaceOrder() async {
    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.obPlaceOrder,
      message: AppTexts.obPlaceOrderConfirmMessage,
      confirmLabel: AppTexts.obPlaceOrder,
    );
    if (confirmed != true) return;
    await placeOrder();
  }

  Future<void> placeOrder() async {
    final active = activeVisit.value;
    if (active == null) return;
    isPlacingOrder.value = true;
    try {
      await _cartService.placeOrder(visitId: active.visitId);
      await _taskService.completeActiveVisit(visitId: active.visitId);
      Get.snackbar(AppTexts.success, AppTexts.obOrderPlacedSuccess);
      _navigateToTodayTasks();
    } catch (_) {
      Get.snackbar(AppTexts.error, AppTexts.error);
    } finally {
      isPlacingOrder.value = false;
    }
  }

  Future<void> endWithoutOrder(String notes) async {
    final active = activeVisit.value;
    if (active == null) return;
    await _cartService.endWithoutOrder(visitId: active.visitId, notes: notes);
    await _taskService.clearActiveVisit(visitId: active.visitId);
    Get.snackbar(AppTexts.success, AppTexts.obVisitClosedSuccess);
    _navigateToTodayTasks();
  }

  Future<void> saveVisitNotes(String notes) async {
    final active = activeVisit.value;
    if (active == null) return;
    await _cartService.saveVisitNotes(visitId: active.visitId, notes: notes);
    Get.snackbar(AppTexts.success, AppTexts.save);
  }

  int maxQuantityForLine(ObVisitCartLineModel line) {
    ObProductModel? product;
    for (final item in products) {
      if (item.id == line.productId) {
        product = item;
        break;
      }
    }
    final remaining = product?.qtyBookable ?? 0;
    return (line.quantity + remaining).floor().clamp(1, 1000000);
  }

  Future<void> promptEndVisitWithoutOrder() async {
    await Get.bottomSheet(
      ObTaskNotesSheet(
        title: AppTexts.obEndVisitTitle,
        hint: AppTexts.obEndVisitNotesHint,
        confirmLabel: AppTexts.confirm,
        required: true,
        initialNotes: null,
        onSave: (notes) => endWithoutOrder(notes),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  Future<void> promptSaveVisitNotes() async {
    await Get.bottomSheet(
      ObTaskNotesSheet(
        title: AppTexts.obSaveVisitNotes,
        hint: AppTexts.obVisitNotesHint,
        confirmLabel: AppTexts.save,
        initialNotes: null,
        onSave: (notes) => saveVisitNotes(notes),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  void _navigateToTodayTasks() {
    Get.offAllNamed(AppRoutes.orderBooker);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<OrderBookerShellController>()) {
        Get.find<OrderBookerShellController>().selectLeaf('ob_today_tasks');
      }
      if (Get.isRegistered<ObRouteDetailController>()) {
        Get.find<ObRouteDetailController>().loadTasks();
      }
    });
  }

  Future<void> _reloadCart() async {
    final active = activeVisit.value;
    if (active == null) return;
    await _loadProductsAndCart(active, active.visitId);
  }
}
