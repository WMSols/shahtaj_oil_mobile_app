import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

class DmWalletController extends GetxController {
  DmWalletController(this._recovery);

  final DmRecoveryService _recovery;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<DmWalletModel> wallet = Rxn<DmWalletModel>();

  bool get hasCachedData => wallet.value != null;

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    load();
  }

  Future<void> load({bool force = true}) async {
    final showLoader = wallet.value == null;
    if (showLoader) isLoading.value = true;
    try {
      wallet.value = await _recovery.fetchWallet(forceNetwork: force);
      error.value = null;
    } on ApiException catch (e) {
      error.value = e.message;
      if (wallet.value == null) AppToast.showError(e.message);
    } catch (_) {
      error.value = AppTexts.emptyLoadFailedSubtitle;
      if (wallet.value == null) AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void goToHistory() {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf('dm_collection_history');
  }

  void goToRecoverShops() {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf('dm_today_shops');
  }
}
