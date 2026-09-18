import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/plan/dm_plan_today_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

class DmOrdersController extends GetxController {
  DmOrdersController(this._planService, this._sessionService);

  final DmPlanService _planService;
  final DmSessionService _sessionService;

  final RxBool isLoading = true.obs;
  final RxBool isActing = false.obs;
  final Rxn<DmFieldState> selectedFieldState = Rxn<DmFieldState>();
  final Rxn<DmPlanTodayModel> plan = Rxn<DmPlanTodayModel>();
  final RxString query = ''.obs;

  static const _filters = [
    DmFieldState.pending,
    DmFieldState.inTransit,
    DmFieldState.notAttended,
    DmFieldState.failed,
    DmFieldState.done,
  ];

  List<DmFieldState> get filterStates => _filters;

  DmSessionState? get sessionState =>
      plan.value?.session?.state ?? _sessionService.current?.state;

  bool get canDepart => sessionState == DmSessionState.office;
  bool get canEndDay => sessionState == DmSessionState.onTheWay;

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    loadPlan();
  }

  Future<void> loadPlan({bool force = true}) async {
    isLoading.value = true;
    try {
      plan.value = await _planService.fetchToday(forceNetwork: force);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(DmFieldState? state) => selectedFieldState.value = state;

  bool isFilterSelected(DmFieldState? state) =>
      selectedFieldState.value == state;

  void onQueryChanged(String value) => query.value = value.trim().toLowerCase();

  List<DmJobModel> get visibleJobs {
    final jobs = plan.value?.jobs ?? const <DmJobModel>[];
    final filter = selectedFieldState.value;
    final q = query.value;
    return jobs
        .where((job) {
          if (filter != null && job.fieldState != filter) return false;
          if (q.isEmpty) return true;
          return job.shopName.toLowerCase().contains(q) ||
              (job.orderName?.toLowerCase().contains(q) ?? false) ||
              (job.shopAddress?.toLowerCase().contains(q) ?? false) ||
              job.jobId.toString().contains(q);
        })
        .toList(growable: false);
  }

  void openJob(DmJobModel job) {
    Get.toNamed(AppRoutes.dmJobDetail.replaceFirst(':id', '${job.jobId}'));
  }

  void openFreeDeliver() {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf('dm_free_deliver');
  }

  Future<void> depart() async {
    if (!canDepart || isActing.value) return;
    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmDepartTitle,
      message: AppTexts.dmDepartConfirmMessage,
      confirmLabel: AppTexts.dmDepartTitle,
    );
    if (confirmed != true) return;

    isActing.value = true;
    try {
      await _sessionService.depart();
      await loadPlan(force: true);
      AppToast.showSuccess(AppTexts.dmDepartSuccess);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> endDay() async {
    if (!canEndDay || isActing.value) return;
    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmEndDayTitle,
      message: AppTexts.dmEndDayConfirmMessage,
      confirmLabel: AppTexts.dmEndDayTitle,
    );
    if (confirmed != true) return;

    isActing.value = true;
    try {
      await _sessionService.end();
      await loadPlan(force: true);
      AppToast.showSuccess(AppTexts.dmEndDaySuccess);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }
}
