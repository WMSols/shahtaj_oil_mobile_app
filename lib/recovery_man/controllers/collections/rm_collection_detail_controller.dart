import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmCollectionDetailController extends GetxController with CachedLoadMixin {
  RmCollectionDetailController(this._store);

  final RmCollectionStore _store;
  final Rxn<RmCollectionSummaryModel> collection =
      Rxn<RmCollectionSummaryModel>();

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
    RecoveryManServicesBinding.ensureRegistered();
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
