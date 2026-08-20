import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/handover/rm_handover_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmHandoverController extends GetxController with CachedLoadMixin {
  RmHandoverController(this._store);

  final RmCollectionStore _store;

  final RxList<RmCollectionSummaryModel> bagCollections =
      <RmCollectionSummaryModel>[].obs;
  final RxList<RmHandoverSummaryModel> recentHandovers =
      <RmHandoverSummaryModel>[].obs;
  final RxDouble cashInBag = 0.0.obs;
  final RxDouble chequeInBag = 0.0.obs;
  final RxDouble bagTotal = 0.0.obs;

  @override
  bool get hasCachedData =>
      bagCollections.isNotEmpty || recentHandovers.isNotEmpty;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  bool get canHandOver => bagCollections.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    RecoveryManServicesBinding.ensureRegistered();
    loadHandover();
  }

  Future<void> loadHandover({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _store.hydrate();
    bagCollections.assignAll(_store.bagCollections);
    recentHandovers.assignAll(_store.recentHandovers);
    cashInBag.value = _store.cashInBag;
    chequeInBag.value = _store.chequeInBag;
    bagTotal.value = _store.bagTotal;
  }

  String collectionTimeLabel(RmCollectionSummaryModel collection) {
    return '${AppFormatter.shortDate(collection.collectedAt)} • ${AppFormatter.timeOfDay(collection.collectedAt)}';
  }

  String handoverTimeLabel(RmHandoverSummaryModel handover) {
    return '${AppFormatter.shortDate(handover.handedAt)} • ${AppFormatter.timeOfDay(handover.handedAt)}';
  }

  void openCollection(RmCollectionSummaryModel collection) {
    Get.toNamed(
      AppRoutes.rmCollectionDetail.replaceFirst(':id', collection.id),
      arguments: {'collectionId': collection.id},
    );
  }

  void openHandover(RmHandoverSummaryModel handover) {
    Get.toNamed(
      AppRoutes.rmHandoverDetail.replaceFirst(':id', handover.id),
      arguments: {'handoverId': handover.id},
    );
  }

  void openConfirm() {
    if (!canHandOver) return;
    Get.toNamed(AppRoutes.rmHandoverConfirm);
  }
}
