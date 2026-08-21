import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmCollectionDetailController extends GetxController with CachedLoadMixin {
  DmCollectionDetailController(this._store);

  final DmCollectionStore _store;
  final Rxn<DmCollectionSummaryModel> collection =
      Rxn<DmCollectionSummaryModel>();

  String get collectionId {
    final fromParams = Get.parameters['id'];
    if (fromParams != null && fromParams.isNotEmpty) return fromParams;
    final args = Get.arguments;
    if (args is Map && args['collectionId'] != null) {
      return args['collectionId'].toString();
    }
    return '';
  }

  @override
  bool get hasCachedData => collection.value != null;

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
    collection.value = _store.collectionById(collectionId);
  }
}
