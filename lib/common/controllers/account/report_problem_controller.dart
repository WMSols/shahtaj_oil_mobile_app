import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/account/report_problem_kind.dart';
import 'package:shahtaj_oil_mobile_app/common/services/account/report_problem_service.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class ReportProblemController extends GetxController {
  ReportProblemController(this._service, this._session);

  final ReportProblemService _service;
  final SessionService _session;

  final Rxn<ReportProblemKind> selectedKind = Rxn<ReportProblemKind>();
  final RxString details = ''.obs;
  final RxBool isSubmitting = false.obs;

  UserRole get role =>
      _session.role.value ?? _session.user.value?.role ?? UserRole.orderBooker;

  List<ReportProblemKind> get chips => ReportProblemKindX.chipsFor(role);

  bool get canSubmit {
    final text = details.value.trim();
    if (selectedKind.value == ReportProblemKind.other) return text.isNotEmpty;
    return selectedKind.value != null || text.isNotEmpty;
  }

  void selectKind(ReportProblemKind kind) {
    if (selectedKind.value == kind) {
      selectedKind.value = null;
      return;
    }
    selectedKind.value = kind;
  }

  void onDetailsChanged(String value) => details.value = value;

  Future<void> submit() async {
    if (isSubmitting.value) return;

    final kind = selectedKind.value;
    final text = details.value.trim();
    if (kind == ReportProblemKind.other && text.isEmpty) {
      AppToast.showError(AppTexts.reportProblemOtherNeedText);
      return;
    }
    if (kind == null && text.isEmpty) {
      AppToast.showError(AppTexts.reportProblemNeedChipOrText);
      return;
    }

    isSubmitting.value = true;
    try {
      await _service.submit(kind: kind, details: text);
      AppToast.showSuccess(AppTexts.reportProblemSent);
      Get.back();
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }
}
