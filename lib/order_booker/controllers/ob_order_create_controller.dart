import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/order_booker_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_route_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_product_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_shop_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_cart_service.dart';

class ObOrderCreateController extends GetxController {
  ObOrderCreateController(
    this._taskService,
    this._cartService,
    this._shopService,
  );

  final ObTaskService _taskService;
  final ObVisitCartService _cartService;
  final ObShopService _shopService;

  final RxBool isLoading = true.obs;
  final RxBool isPlacingOrder = false.obs;
  final RxnString error = RxnString();
  final Rxn<ObActiveVisitModel> activeVisit = Rxn<ObActiveVisitModel>();
  final Rxn<ObShopModel> shop = Rxn<ObShopModel>();
  final RxList<ObProductModel> products = <ObProductModel>[].obs;
  final Rxn<ObVisitCartModel> cart = Rxn<ObVisitCartModel>();

  /// Typed qty drafts / field errors keyed by cart line id.
  final RxMap<int, String> qtyDrafts = <int, String>{}.obs;
  final RxMap<int, String?> qtyErrors = <int, String?>{}.obs;
  final RxMap<int, double?> qtyPreviews = <int, double?>{}.obs;

  int? get visitId =>
      Get.arguments is Map ? (Get.arguments as Map)['visitId'] as int? : null;

  bool get hasCartLines => (cart.value?.lines.isNotEmpty ?? false);

  bool isProductInCart(int productId) {
    final lines = cart.value?.lines;
    if (lines == null) return false;
    return lines.any((line) => line.productId == productId);
  }

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
      await Future.wait([
        _loadProductsAndCart(active, resolvedVisitId),
        _loadShop(active),
      ]);
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = AppTexts.error;
    } finally {
      isLoading.value = false;
    }
  }

  /// Credit fields come from shop APIs only (`shops/get`, fallback `shops/mine`).
  Future<void> _loadShop(ObActiveVisitModel active) async {
    shop.value = null;
    if (active.shopId.isEmpty) return;

    try {
      shop.value = await _shopService.fetchShop(active.shopId);
      return;
    } catch (_) {
      // Fall through to shops/mine.
    }

    try {
      final shops = await _shopService.fetchShops();
      for (final item in shops) {
        if (item.id == active.shopId) {
          shop.value = item;
          return;
        }
      }
    } catch (_) {
      // Credit summary is optional for order placement.
    }
  }

  Future<void> _loadProductsAndCart(ObActiveVisitModel active, int id) async {
    products.assignAll(await _cartService.fetchProducts(visitId: id));
    cart.value = await _cartService.fetchCart(
      visitId: id,
      shopName: active.shopName,
    );
    _pruneQtyStateToCurrentLines();
  }

  void _pruneQtyStateToCurrentLines() {
    final lines = cart.value?.lines ?? const <ObVisitCartLineModel>[];
    final ids = lines.map((l) => l.lineId).toSet();

    qtyDrafts.removeWhere((id, _) => !ids.contains(id));
    qtyErrors.removeWhere((id, _) => !ids.contains(id));
    qtyPreviews.removeWhere((id, _) => !ids.contains(id));

    for (final line in lines) {
      final draft = qtyDrafts[line.lineId];
      if (draft == null) continue;
      final parsed = double.tryParse(draft.trim());
      final maxQty = maxQuantityForLine(line);
      // Keep over-max drafts/errors; clear drafts that match server qty.
      if (parsed != null && parsed > maxQty) continue;
      if (parsed != null && parsed == line.quantity) {
        qtyDrafts.remove(line.lineId);
        qtyErrors.remove(line.lineId);
        qtyPreviews.remove(line.lineId);
      }
    }
    qtyDrafts.refresh();
    qtyErrors.refresh();
    qtyPreviews.refresh();
  }

  Future<void> addProduct(ObProductModel product) async {
    final active = activeVisit.value;
    if (active == null) return;
    if (isProductInCart(product.id)) return;
    try {
      await _cartService.addLine(
        visitId: active.visitId,
        productId: product.id,
      );
      await _reloadCart();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    }
  }

  ObVisitCartLineModel? lineById(int lineId) {
    final lines = cart.value?.lines;
    if (lines == null) return null;
    for (final line in lines) {
      if (line.lineId == lineId) return line;
    }
    return null;
  }

  String formatQuantity(double qty) {
    if (qty == qty.roundToDouble()) return qty.round().toString();
    return qty.toStringAsFixed(1);
  }

  String quantityFieldText(ObVisitCartLineModel line) {
    return qtyDrafts[line.lineId] ?? '';
  }

  String? quantityError(int lineId) => qtyErrors[lineId];

  double displayQuantity(ObVisitCartLineModel line) {
    return qtyPreviews[line.lineId] ?? line.quantity;
  }

  double displayLineTotal(ObVisitCartLineModel line) {
    return displayQuantity(line) * line.priceUnit;
  }

  /// Live cart subtotal from quantity drafts / previews (not only API cart).
  double displaySubtotal() {
    final current = cart.value;
    if (current == null) return 0;
    // Touch map so Obx rebuilds while typing.
    qtyPreviews.length;
    return current.lines.fold<double>(
      0,
      (sum, line) => sum + displayLineTotal(line),
    );
  }

  String bookableLabel(ObVisitCartLineModel line) {
    final remaining = bookableRemainingForLine(line);
    if (remaining <= 0) return '0';
    if (remaining == remaining.roundToDouble()) {
      return remaining.toInt().toString();
    }
    return remaining.toStringAsFixed(1);
  }

  /// Live validation while typing. Does not call the API.
  void onQuantityInputChanged(int lineId, String raw) {
    final line = lineById(lineId);
    if (line == null) return;

    qtyDrafts[lineId] = raw;
    final parsed = double.tryParse(raw.trim());
    if (parsed == null || parsed < 1) {
      qtyErrors[lineId] = null;
      qtyPreviews[lineId] = null;
      qtyDrafts.refresh();
      qtyErrors.refresh();
      qtyPreviews.refresh();
      return;
    }

    final maxQty = maxQuantityForLine(line);
    if (parsed > maxQty) {
      qtyErrors[lineId] = AppTexts.obNotEnoughStock(maxQty.toString());
      qtyPreviews[lineId] = parsed;
      qtyDrafts.refresh();
      qtyErrors.refresh();
      qtyPreviews.refresh();
      return;
    }

    qtyErrors[lineId] = null;
    qtyPreviews[lineId] = parsed;
    qtyDrafts.refresh();
    qtyErrors.refresh();
    qtyPreviews.refresh();
  }

  /// Commit on blur / done. Over-max keeps typed value and blocks API.
  Future<void> commitQuantityInput(int lineId) async {
    final line = lineById(lineId);
    if (line == null) return;

    final raw = (qtyDrafts[lineId] ?? '').trim();
    final parsed = double.tryParse(raw);

    if (raw.isEmpty || parsed == null || parsed < 1) {
      qtyDrafts.remove(lineId);
      qtyErrors[lineId] = null;
      qtyPreviews[lineId] = null;
      qtyDrafts.refresh();
      qtyErrors.refresh();
      qtyPreviews.refresh();
      return;
    }

    final maxQty = maxQuantityForLine(line);
    if (parsed > maxQty) {
      qtyDrafts[lineId] = raw;
      qtyErrors[lineId] = AppTexts.obNotEnoughStock(maxQty.toString());
      qtyPreviews[lineId] = parsed;
      qtyDrafts.refresh();
      qtyErrors.refresh();
      qtyPreviews.refresh();
      return;
    }

    qtyErrors[lineId] = null;
    qtyPreviews[lineId] = parsed;
    qtyDrafts[lineId] = formatQuantity(parsed);
    qtyDrafts.refresh();
    qtyErrors.refresh();
    qtyPreviews.refresh();

    if (parsed != line.quantity) {
      await updateQuantity(lineId, parsed);
    }
  }

  Future<void> updateQuantity(int lineId, double quantity) async {
    final active = activeVisit.value;
    final currentCart = cart.value;
    if (active == null || currentCart == null) return;

    final oldLine = lineById(lineId);
    if (oldLine == null) return;

    final maxQty = maxQuantityForLine(oldLine);
    if (quantity < 1 || quantity > maxQty) {
      AppToast.showError(AppTexts.obNotEnoughStock(maxQty.toString()));
      return;
    }

    if (quantity == oldLine.quantity) return;

    final optimisticLines = currentCart.lines
        .map(
          (line) =>
              line.lineId == lineId ? line.copyWith(quantity: quantity) : line,
        )
        .toList(growable: false);
    cart.value = currentCart.copyWith(lines: optimisticLines);

    try {
      await _cartService.updateLine(
        visitId: active.visitId,
        lineId: lineId,
        quantity: quantity,
      );
      await _reloadCart();
    } on ApiException catch (e) {
      await _reloadCart();
      AppToast.showError(e.message);
    } catch (_) {
      await _reloadCart();
      AppToast.showError(AppTexts.error);
    }
  }

  Future<void> removeLine(int lineId) async {
    final active = activeVisit.value;
    if (active == null) return;
    qtyDrafts.remove(lineId);
    qtyErrors.remove(lineId);
    qtyPreviews.remove(lineId);
    try {
      await _cartService.removeLine(visitId: active.visitId, lineId: lineId);
      await _reloadCart();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    }
  }

  bool _hasQuantityInputIssues() {
    final lines = cart.value?.lines ?? const <ObVisitCartLineModel>[];
    for (final line in lines) {
      final maxQty = maxQuantityForLine(line);
      if (line.quantity < 1 || line.quantity > maxQty) return true;

      final error = qtyErrors[line.lineId];
      if (error != null && error.isNotEmpty) return true;

      final draft = qtyDrafts[line.lineId];
      if (draft == null) continue;
      final parsed = double.tryParse(draft.trim());
      if (parsed != null && parsed > maxQty) return true;
    }
    return false;
  }

  Future<void> promptPlaceOrder() async {
    final currentCart = cart.value;
    if (currentCart == null || currentCart.lines.isEmpty) return;

    if (_hasQuantityInputIssues()) {
      // Prefer a concrete line error when present.
      for (final line in currentCart.lines) {
        final maxQty = maxQuantityForLine(line);
        final draft = qtyDrafts[line.lineId];
        final parsed = draft == null ? null : double.tryParse(draft.trim());
        if ((parsed != null && parsed > maxQty) ||
            (qtyErrors[line.lineId]?.isNotEmpty ?? false) ||
            line.quantity > maxQty) {
          AppToast.showError(AppTexts.obNotEnoughStock(maxQty.toString()));
          return;
        }
      }
      AppToast.showError(AppTexts.error);
      return;
    }

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
      AppToast.showSuccess(AppTexts.obOrderPlacedSuccess);
      _navigateToTodayTasks();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isPlacingOrder.value = false;
    }
  }

  /// Remaining free qty from product catalog (excludes this line's qty).
  double bookableRemainingForLine(ObVisitCartLineModel line) {
    for (final item in products) {
      if (item.id == line.productId) return item.qtyBookable;
    }
    return 0;
  }

  /// Max cart qty for a line = current reserved qty + remaining free stock.
  int maxQuantityForLine(ObVisitCartLineModel line) {
    final remaining = bookableRemainingForLine(line);
    final maxQty = (line.quantity + remaining).floor();
    return maxQty < 1 ? 1 : maxQty;
  }

  void promptEndVisitWithoutOrder() {
    final active = activeVisit.value;
    if (active == null) return;
    if (hasCartLines) {
      AppToast.showWarning(AppTexts.obEndVisitRequiresEmptyCart);
      return;
    }
    Get.toNamed(
      AppRoutes.obNotes,
      arguments: {
        'purpose': ObNotesPurpose.endVisitWithoutOrder,
        'visitId': active.visitId,
      },
    );
  }

  void promptSaveVisitNotes() {
    final active = activeVisit.value;
    if (active == null) return;
    Get.toNamed(
      AppRoutes.obNotes,
      arguments: {
        'purpose': ObNotesPurpose.visitNotes,
        'visitId': active.visitId,
      },
    );
  }

  void _navigateToTodayTasks() {
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

  Future<void> _reloadCart() async {
    final active = activeVisit.value;
    if (active == null) return;
    await _loadProductsAndCart(active, active.visitId);
  }
}
