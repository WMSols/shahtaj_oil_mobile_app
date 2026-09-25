import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/reports/report_message_model.dart';
import 'package:shahtaj_oil_mobile_app/common/models/reports/report_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/common/services/reports/reports_service.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/text/app_plain_text.dart';

class ReportDetailController extends GetxController {
  ReportDetailController(this._service);

  final ReportsService _service;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingMessages = true.obs;
  final Rxn<ReportSummaryModel> report = Rxn<ReportSummaryModel>();
  final RxnString error = RxnString();

  int get reportId {
    final param = int.tryParse(Get.parameters['id'] ?? '');
    if (param != null) return param;
    final arg = Get.arguments;
    if (arg is Map && arg['report'] is ReportSummaryModel) {
      return (arg['report'] as ReportSummaryModel).reportId;
    }
    return 0;
  }

  /// Opening user bubble first, then statuses + office replies in time order.
  List<ReportMessageModel> get threadItems {
    final current = report.value;
    if (current == null) return const [];

    final reporterName = (current.reportedBy ?? '').trim();
    final openingBody = AppPlainText.fromHtml(current.description);
    final opening = ReportMessageModel(
      body: openingBody.isEmpty ? current.subject : openingBody,
      authorName: reporterName.isEmpty
          ? AppTexts.reportYouAuthor
          : reporterName,
      createdAt: current.createDate,
      isMine: true,
      isStatus: false,
      sortIndex: -1,
    );

    final followUps = <ReportMessageModel>[];
    var apiNewestFirst = false;
    final dated = current.messages
        .where((m) => m.createdAt != null)
        .toList(growable: false);
    if (dated.length >= 2) {
      final first = dated.first.createdAt!;
      final last = dated.last.createdAt!;
      apiNewestFirst = first.isAfter(last);
    }

    for (final raw in current.messages) {
      final body = AppPlainText.fromHtml(raw.body);
      if (body.isEmpty) continue;

      final author = (raw.authorName ?? '').trim();
      final isReporter =
          raw.isMine ||
          (reporterName.isNotEmpty &&
              author.toLowerCase() == reporterName.toLowerCase());

      final asStatus = raw.isStatus || AppPlainText.looksLikeStatusEvent(body);

      final createdAt = raw.createdAt ?? current.createDate;
      final index = apiNewestFirst
          ? (current.messages.length - 1 - raw.sortIndex)
          : raw.sortIndex;

      if (asStatus) {
        followUps.add(
          raw.copyWith(
            body: body,
            isMine: false,
            isStatus: true,
            hasScreenshot: false,
            createdAt: createdAt,
            sortIndex: index,
          ),
        );
        continue;
      }

      // Opening bubble already covers the reporter submission.
      if (isReporter) continue;

      followUps.add(
        raw.copyWith(
          body: body,
          isMine: false,
          isStatus: false,
          hasScreenshot: false,
          createdAt: createdAt,
          sortIndex: index,
          authorName: author.isEmpty ? AppTexts.reportOfficeAuthor : author,
        ),
      );
    }

    final hasCreateStatus = followUps.any(
      (m) => m.isStatus && AppPlainText.looksLikeCreateNotice(m.body),
    );
    if (!hasCreateStatus) {
      followUps.add(
        ReportMessageModel(
          body: AppTexts.reportCreatedStatus,
          createdAt: current.createDate,
          isStatus: true,
          sortIndex: -1,
        ),
      );
    }

    _sortChronological(followUps);
    return [opening, ...followUps];
  }

  /// Oldest → newest. Prefer timestamp, then id, then API index.
  static void _sortChronological(List<ReportMessageModel> items) {
    items.sort((a, b) {
      final aAt = a.createdAt;
      final bAt = b.createdAt;
      if (aAt != null && bAt != null) {
        final byTime = aAt.compareTo(bAt);
        if (byTime != 0) return byTime;
      } else if (aAt != null) {
        return -1;
      } else if (bAt != null) {
        return 1;
      }

      final aId = a.id;
      final bId = b.id;
      if (aId != null && bId != null && aId != bId) {
        return aId.compareTo(bId);
      }

      return a.sortIndex.compareTo(b.sortIndex);
    });
  }

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Map && arg['report'] is ReportSummaryModel) {
      report.value = arg['report'] as ReportSummaryModel;
      isLoading.value = false;
      isLoadingMessages.value = true;
    }
    load();
  }

  Future<void> load({bool force = false}) async {
    if (reportId == 0) {
      isLoading.value = false;
      isLoadingMessages.value = false;
      error.value = AppTexts.emptyNotFoundTitle;
      return;
    }

    if (report.value == null) {
      isLoading.value = true;
    }
    isLoadingMessages.value = true;
    try {
      report.value = await _service.fetchReport(
        reportId: reportId,
        includeScreenshot: false,
      );
      error.value = null;
    } catch (_) {
      if (report.value == null) {
        error.value = AppTexts.error;
      }
    } finally {
      isLoading.value = false;
      isLoadingMessages.value = false;
    }
  }
}
