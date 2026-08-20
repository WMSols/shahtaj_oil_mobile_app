import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/dashboard/rm_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/dashboard/rm_targets_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/dashboard/rm_dashboard_service.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_shell_controller.dart';

class RmDashboardController extends GetxController with CachedLoadMixin {
  RmDashboardController(this._service, this._session);

  final RmDashboardService _service;
  final SessionService _session;

  final Rxn<RmDashboardModel> dashboard = Rxn<RmDashboardModel>();

  @override
  bool get hasCachedData => dashboard.value != null;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  String get greeting => AppFormatter.timeOfDayGreeting();
  String get userName => _session.user.value?.name ?? AppTexts.defaultUserName;
  double get collectedToday => dashboard.value?.collectedToday ?? 0;
  double get stillDue => dashboard.value?.stillDue ?? 0;
  double get cashInBag => dashboard.value?.cashInBag ?? 0;
  List<RmCollectionSummaryModel> get recentCollections =>
      dashboard.value?.recentCollections ?? const [];
  RmTargetsModel get targets =>
      dashboard.value?.targets ?? const RmTargetsModel();

  Future<void> loadDashboard({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    dashboard.value = await _service.fetchDashboard();
  }

  void goToTodayShops() {
    if (Get.isRegistered<RecoveryManShellController>()) {
      Get.find<RecoveryManShellController>().selectLeaf('rm_today_shops');
    }
  }

  void goToHistory() {
    if (Get.isRegistered<RecoveryManShellController>()) {
      Get.find<RecoveryManShellController>().selectLeaf('rm_history');
    }
  }

  void goToHandover() {
    if (Get.isRegistered<RecoveryManShellController>()) {
      Get.find<RecoveryManShellController>().selectLeaf('rm_handover');
    }
  }

  void openCollection(RmCollectionSummaryModel collection) {
    Get.toNamed(
      AppRoutes.rmCollectionDetail.replaceFirst(':id', collection.id),
      arguments: {'collectionId': collection.id},
    );
  }
}
