import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/handover/dm_handover_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmHandoverController extends GetxController with CachedLoadMixin {
  DmHandoverController(this._store);

  final DmCollectionStore _store;

  final RxList<DmCollectionSummaryModel> bagCollections =
      <DmCollectionSummaryModel>[].obs;
  final RxList<DmHandoverSummaryModel> recentHandovers =
      <DmHandoverSummaryModel>[].obs;
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
    DmServicesBinding.ensureRegistered();
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

  String collectionTimeLabel(DmCollectionSummaryModel collection) {
    return '${AppFormatter.shortDate(collection.collectedAt)} • ${AppFormatter.timeOfDay(collection.collectedAt)}';
  }

  String handoverTimeLabel(DmHandoverSummaryModel handover) {
    return '${AppFormatter.shortDate(handover.handedAt)} • ${AppFormatter.timeOfDay(handover.handedAt)}';
  }

  void openCollection(DmCollectionSummaryModel collection) {
    Get.toNamed(
      AppRoutes.dmCollectionDetail.replaceFirst(':id', collection.id),
      arguments: {'collectionId': collection.id},
    );
  }

  void openHandover(DmHandoverSummaryModel handover) {
    Get.toNamed(
      AppRoutes.dmHandoverDetail.replaceFirst(':id', handover.id),
      arguments: {'handoverId': handover.id},
    );
  }

  void openConfirm() {
    if (!canHandOver) return;
    Get.toNamed(AppRoutes.dmHandoverConfirm);
  }
}
