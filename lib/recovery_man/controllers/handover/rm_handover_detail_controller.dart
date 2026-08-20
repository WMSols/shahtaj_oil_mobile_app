import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/handover/rm_handover_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmHandoverDetailController extends GetxController with CachedLoadMixin {
  RmHandoverDetailController(this._store);

  final RmCollectionStore _store;
  final Rxn<RmHandoverSummaryModel> handover = Rxn<RmHandoverSummaryModel>();
  final RxList<RmCollectionSummaryModel> collections =
      <RmCollectionSummaryModel>[].obs;

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
    RecoveryManServicesBinding.ensureRegistered();
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

  String collectionTimeLabel(RmCollectionSummaryModel collection) {
    return '${AppFormatter.shortDate(collection.collectedAt)} • ${AppFormatter.timeOfDay(collection.collectedAt)}';
  }

  String handedAtLabel(RmHandoverSummaryModel item) {
    return '${AppFormatter.shortDate(item.handedAt)} • ${AppFormatter.timeOfDay(item.handedAt)}';
  }

  void openCollection(RmCollectionSummaryModel collection) {
    Get.toNamed(
      AppRoutes.rmCollectionDetail.replaceFirst(':id', collection.id),
      arguments: {'collectionId': collection.id},
    );
  }
}
