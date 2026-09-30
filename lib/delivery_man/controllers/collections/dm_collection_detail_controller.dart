import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_collection_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmCollectionDetailController extends GetxController {
  DmCollectionDetailController(this._recovery);

  final DmRecoveryService _recovery;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<DmWalletCollectionModel> collection =
      Rxn<DmWalletCollectionModel>();

  int get collectionId {
    final fromParams = int.tryParse(Get.parameters['id'] ?? '');
    if (fromParams != null && fromParams > 0) return fromParams;
    final args = Get.arguments;
    if (args is DmWalletCollectionModel) return args.paymentId;
    if (args is Map) {
      final id = args['collectionId'] ?? args['paymentId'] ?? args['id'];
      return int.tryParse(id?.toString() ?? '') ?? 0;
    }
    return 0;
  }

  bool get hasCachedData => collection.value != null;

  @override
  void onInit() {
    super.onInit();
    DmServicesBinding.ensureRegistered();
    loadDetail();
  }

  Future<void> loadDetail({bool force = false}) async {
    final arg = Get.arguments;
    if (arg is DmWalletCollectionModel && !force) {
      collection.value = arg;
      isLoading.value = false;
      error.value = null;
      return;
    }
    if (arg is Map && arg['collection'] is DmWalletCollectionModel && !force) {
      collection.value = arg['collection'] as DmWalletCollectionModel;
      isLoading.value = false;
      error.value = null;
      return;
    }

    if (collection.value == null) isLoading.value = true;
    try {
      final page = await _recovery.fetchCollections(forceNetwork: force);
      final id = collectionId;
      DmWalletCollectionModel? match;
      for (final row in page.collections) {
        if (row.paymentId == id) {
          match = row;
          break;
        }
      }
      if (match == null && id > 0) {
        error.value = AppTexts.dmCollectionNotFound;
        if (collection.value == null) {
          throw ApiException(message: AppTexts.dmCollectionNotFound);
        }
      } else {
        collection.value = match;
        error.value = null;
      }
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = AppTexts.emptyLoadFailedSubtitle;
    } finally {
      isLoading.value = false;
    }
  }
}
