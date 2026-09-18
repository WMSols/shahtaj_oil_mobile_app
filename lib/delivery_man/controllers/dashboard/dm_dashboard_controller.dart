import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_dashboard_activity_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_load_today_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/plan/dm_plan_today_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/session/dm_session_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_snapshot_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/load/dm_load_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

class DmDashboardController extends GetxController {
  DmDashboardController(
    this._sessionService,
    this._loadService,
    this._planService,
    this._vanService,
    this._recoveryService,
  );

  final DmSessionService _sessionService;
  final DmLoadService _loadService;
  final DmPlanService _planService;
  final DmVanService _vanService;
  final DmRecoveryService _recoveryService;
  final SessionService _session = Get.find<SessionService>();

  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString error = RxnString();

  final Rxn<DmSessionState> sessionState = Rxn<DmSessionState>();
  final RxInt pendingCount = 0.obs;
  final RxInt inTransitCount = 0.obs;
  final RxInt deliveredCount = 0.obs;
  final RxBool hasRemainingPick = false.obs;
  final RxDouble vanOnHandTotal = 0.0.obs;
  final RxDouble collectedToday = 0.0.obs;
  final RxDouble walletBalance = 0.0.obs;
  final RxDouble settledTotal = 0.0.obs;
  final Rxn<DmJobModel> nextJob = Rxn<DmJobModel>();
  final RxList<DmStockItemModel> stockItems = <DmStockItemModel>[].obs;

  Future<void> refreshCollections() => load(force: true);

  bool get hasContent =>
      sessionState.value != null ||
      pendingCount.value + inTransitCount.value + deliveredCount.value > 0 ||
      stockItems.isNotEmpty ||
      walletBalance.value > 0 ||
      collectedToday.value > 0;

  bool get showNextDeliveryStop =>
      nextJob.value != null && nextAction?.kind != DmNextActionKind.deliver;

  String get greeting => AppFormatter.timeOfDayGreeting();
  String get userName =>
      _session.user.value?.displayName('Delivery Man') ?? 'Delivery Man';

  DmNextActionModel? get nextAction {
    final state = sessionState.value;
    if (state == null || state == DmSessionState.ended) return null;

    if (state == DmSessionState.office) {
      if (hasRemainingPick.value) {
        return DmNextActionModel(
          kind: DmNextActionKind.pickup,
          message: AppTexts.dmNextPickupSubtitle,
          buttonLabel: AppTexts.dmPickupTitle,
        );
      }
      return DmNextActionModel(
        kind: DmNextActionKind.depart,
        message: AppTexts.dmNextDepartSubtitle,
        buttonLabel: AppTexts.dmDepartTitle,
      );
    }

    final job = nextJob.value;
    if (job != null) {
      return DmNextActionModel(
        kind: DmNextActionKind.deliver,
        message: job.shopName,
        buttonLabel: AppTexts.dmContinueDeliveries,
      );
    }

    if (vanOnHandTotal.value > 0) {
      return DmNextActionModel(
        kind: DmNextActionKind.unload,
        message: AppTexts.dmNextUnloadSubtitle,
        buttonLabel: AppTexts.dmVanModeReturnToWh,
      );
    }

    if (walletBalance.value > 0) {
      return DmNextActionModel(
        kind: DmNextActionKind.collect,
        message: AppTexts.dmWalletNudgeSubtitle(
          AppFormatter.compactCurrency(walletBalance.value),
        ),
        buttonLabel: AppTexts.dmWalletTitle,
      );
    }

    return DmNextActionModel(
      kind: DmNextActionKind.endDay,
      message: AppTexts.dmNextEndDaySubtitle,
      buttonLabel: AppTexts.dmEndDayTitle,
    );
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool force = true}) async {
    final showFullLoader = !hasContent;
    if (showFullLoader) {
      isLoading.value = true;
    } else {
      isRefreshing.value = true;
    }

    try {
      late final DmSessionModel session;
      late final DmLoadTodayModel load;
      late final DmPlanTodayModel plan;
      late final DmVanSnapshotModel van;
      late final DmWalletModel wallet;

      await Future.wait([
        _sessionService
            .fetchSession(forceNetwork: force)
            .then((v) => session = v),
        _loadService.fetchToday(forceNetwork: force).then((v) => load = v),
        _planService.fetchToday(forceNetwork: force).then((v) => plan = v),
        _vanService.fetchSnapshot(forceNetwork: force).then((v) => van = v),
        _recoveryService
            .fetchWallet(forceNetwork: force)
            .then((v) => wallet = v),
      ]);

      sessionState.value = session.state;

      final jobs = plan.jobs;
      pendingCount.value = jobs
          .where((j) => j.fieldState == DmFieldState.pending)
          .length;
      inTransitCount.value = jobs
          .where((j) => j.fieldState == DmFieldState.inTransit)
          .length;
      deliveredCount.value = jobs
          .where(
            (j) =>
                j.fieldState == DmFieldState.done ||
                j.state == DmJobState.delivered,
          )
          .length;

      hasRemainingPick.value = load.pickLines.any(
        (line) => line.qtyStill > 0 || line.qtyToPick > 0,
      );

      vanOnHandTotal.value = van.qtyTotal;
      collectedToday.value = wallet.collectedToday;
      walletBalance.value = wallet.balance;
      settledTotal.value = wallet.settledTotal;

      final mapped = [
        for (final item in van.items)
          DmStockItemModel(
            id: '${item.productId}',
            name: item.name,
            quantity: item.qty.round(),
            onHandQuantity: item.qty.round(),
            unit: item.uom ?? '',
            isLowStock: item.qty <= 0,
          ),
      ]..sort((a, b) => a.name.compareTo(b.name));
      stockItems.assignAll(mapped);

      final open = jobs
          .where(
            (j) =>
                j.fieldState == DmFieldState.pending ||
                j.fieldState == DmFieldState.inTransit,
          )
          .toList(growable: false);
      open.sort((a, b) {
        final rank = _fieldRank(
          a.fieldState,
        ).compareTo(_fieldRank(b.fieldState));
        if (rank != 0) return rank;
        final aAt = a.scheduledDate ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bAt = b.scheduledDate ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aAt.compareTo(bAt);
      });
      nextJob.value = open.isEmpty ? null : open.first;
      error.value = null;
    } catch (_) {
      if (!hasContent) {
        error.value = AppTexts.emptyLoadFailedSubtitle;
      }
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  int _fieldRank(DmFieldState state) => switch (state) {
    DmFieldState.inTransit => 0,
    DmFieldState.pending => 1,
    _ => 2,
  };

  void runNextAction() {
    switch (nextAction?.kind) {
      case DmNextActionKind.pickup:
        goToPickup();
      case DmNextActionKind.depart:
      case DmNextActionKind.endDay:
        goToOrders();
      case DmNextActionKind.deliver:
        openNextJob();
      case DmNextActionKind.unload:
        goToVanStock();
      case DmNextActionKind.collect:
        goToWallet();
      case DmNextActionKind.handover:
      case null:
        break;
    }
  }

  void goToPickup() => _selectLeaf('dm_pickup');

  void goToVanStock() => _selectLeaf('dm_van_stock');

  void goToOrders() => _selectLeaf('dm_orders');

  void goToFreeDeliver() => _selectLeaf('dm_free_deliver');

  void goToWallet() => _selectLeaf('dm_wallet');

  void goToRecoverShops() => _selectLeaf('dm_today_shops');

  void goToCollectionHistory() => _selectLeaf('dm_collection_history');

  void openNextJob() {
    final job = nextJob.value;
    if (job == null) {
      goToOrders();
      return;
    }
    Get.toNamed(AppRoutes.dmJobDetail.replaceFirst(':id', '${job.jobId}'));
  }

  void _selectLeaf(String id) {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf(id);
  }
}
