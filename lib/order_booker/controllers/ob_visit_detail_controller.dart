import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_service.dart';

class ObVisitDetailController extends GetxController {
  ObVisitDetailController(this._visitService);

  final ObVisitService _visitService;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<ObVisitDetailModel> visit = Rxn<ObVisitDetailModel>();

  int? get visitId => int.tryParse(Get.parameters['id'] ?? '');

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    final id = visitId;
    if (id == null) {
      error.value = AppTexts.obVisitNotFound;
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    error.value = null;
    try {
      visit.value = await _visitService.fetchVisitDetail(visitId: id);
    } catch (_) {
      visit.value = null;
      error.value = AppTexts.obVisitNotFound;
    } finally {
      isLoading.value = false;
    }
  }

  String formatDateTime(DateTime? value) {
    if (value == null) return AppTexts.notAvailable;
    return '${AppFormatter.shortDate(value)} • ${AppFormatter.timeOfDay(value)}';
  }

  String? get notes => visit.value?.notes;

  bool get hasNotes => notes != null && notes!.trim().isNotEmpty;

  Future<void> callOwner() async {
    final phone = visit.value?.shopPhone;
    if (phone == null || phone.trim().isEmpty) return;

    final normalized = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: normalized);
    try {
      await launchUrl(uri);
    } catch (e, stackTrace) {
      debugPrint('ObVisitDetailController: call failed — $e');
      debugPrint('$stackTrace');
    }
  }

  Future<void> openDirections() async {
    final current = visit.value;
    if (current?.latitude == null || current?.longitude == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${current!.latitude},${current.longitude}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, stackTrace) {
      debugPrint('ObVisitDetailController: directions failed — $e');
      debugPrint('$stackTrace');
    }
  }

  void openOrder() {
    final current = visit.value;
    if (current == null || !current.hasOrder) return;
    Get.toNamed(
      AppRoutes.obOrderDetail.replaceFirst(':id', '${current.visitId}'),
      arguments: {'visitId': current.visitId, 'visitDetail': current},
    );
  }
}
