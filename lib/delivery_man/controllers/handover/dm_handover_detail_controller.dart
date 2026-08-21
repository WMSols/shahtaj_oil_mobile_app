import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/handover/dm_handover_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmHandoverDetailController extends GetxController with CachedLoadMixin {
  DmHandoverDetailController(this._store);

  final DmCollectionStore _store;
  final Rxn<DmHandoverSummaryModel> handover = Rxn<DmHandoverSummaryModel>();
  final RxList<DmCollectionSummaryModel> collections =
      <DmCollectionSummaryModel>[].obs;

  String get handoverId {
    final fromParams = Get.parameters['id'];
    if (fromParams != null && fromParams.isNotEmpty) return fromParams;
    final args = Get.arguments;
    if (args is Map && args['handoverId'] != null) {
      return args['handoverId'].toString();
    }
    return '';
  }

  @override
  bool get hasCachedData => handover.value != null;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  @override
  void onInit() {
    super.onInit();
    DmServicesBinding.ensureRegistered();
    loadDetail();
  }

  Future<void> loadDetail({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await _store.hydrate();
    handover.value = _store.handoverById(handoverId);
    collections.assignAll(_store.collectionsForHandover(handoverId));
  }

  String collectionTimeLabel(DmCollectionSummaryModel collection) {
    return '${AppFormatter.shortDate(collection.collectedAt)} • ${AppFormatter.timeOfDay(collection.collectedAt)}';
  }

  String handedAtLabel(DmHandoverSummaryModel item) {
    return '${AppFormatter.shortDate(item.handedAt)} • ${AppFormatter.timeOfDay(item.handedAt)}';
  }

  void openCollection(DmCollectionSummaryModel collection) {
    Get.toNamed(
      AppRoutes.dmCollectionDetail.replaceFirst(':id', collection.id),
      arguments: {'collectionId': collection.id},
    );
  }
}
