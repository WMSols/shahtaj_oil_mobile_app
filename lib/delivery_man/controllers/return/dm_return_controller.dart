import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/return/dm_return_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/return/dm_return_service.dart';

class DmReturnController extends GetxController {
  DmReturnController(this._returnService);

  final DmReturnService _returnService;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<DmReturnModel> template = Rxn<DmReturnModel>();
  final Rxn<DmReturnModel> submittedReturn = Rxn<DmReturnModel>();
  final RxString notes = ''.obs;

  bool get isSubmitted => template.value?.submitted ?? false;

  bool get isEmptyReturn {
    final model = template.value;
    if (model == null) return true;
    return model.leftover.isEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    loadTemplate();
  }

  Future<void> loadTemplate() async {
    isLoading.value = true;
    try {
      final data = await _returnService.fetchReturnTemplate();
      template.value = data;
      if (data.submitted) {
        submittedReturn.value = data;
        notes.value = data.notes ?? '';
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onNotesChanged(String value) => notes.value = value;

  void updateLeftoverQty(int index, String raw) {
    final current = template.value;
    if (current == null || current.submitted) return;
    final qty = int.tryParse(raw.trim());
    if (qty == null || qty < 0) return;
    final lines = List<DmReturnLineModel>.from(current.leftover);
    if (index < 0 || index >= lines.length) return;
    lines[index] = lines[index].copyWith(quantity: qty);
    template.value = current.copyWith(leftover: lines);
  }

  void goToDashboard() {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf('dm_dashboard');
  }

  Future<void> submitReturn() async {
    final current = template.value;
    if (current == null) return;
    if (current.submitted) {
      AppToast.showWarning(AppTexts.dmReturnAlreadySubmitted);
      return;
    }
    if (isEmptyReturn) {
      AppToast.showWarning(AppTexts.dmNoActiveOrdersForReturn);
      return;
    }

    isSubmitting.value = true;
    try {
      submittedReturn.value = await _returnService.submitReturn(
        current.copyWith(
          notes: notes.value.trim().isEmpty ? null : notes.value.trim(),
        ),
      );
      template.value = submittedReturn.value;
      AppToast.showSuccess(AppTexts.dmReturnSubmitted);
      goToDashboard();
    } finally {
      isSubmitting.value = false;
    }
  }
}
