import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/reports/report_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/common/models/reports/report_tag_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_build_info.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/local_media_store.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/sync/outbox_payload.dart';

class ReportSubmitResult {
  const ReportSubmitResult({required this.queued, this.report});

  final bool queued;
  final ReportSummaryModel? report;
}

/// Field reports for both Order Booker and Delivery Man (endpoint prefix differs).
class ReportsService extends GetxService {
  ReportsService(this._api);

  final ApiClient _api;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  String? _deviceInfoCache;

  OfflineCacheService get _cache => Get.find<OfflineCacheService>();
  SyncOutboxService get _outbox => Get.find<SyncOutboxService>();
  LocalMediaStore get _media => Get.find<LocalMediaStore>();
  SessionService get _session => Get.find<SessionService>();

  List<ReportTagModel>? _tagsMemory;

  bool get _canReachServer {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return false;
    return connectivity.quality.value != NetworkQuality.weak;
  }

  UserRole get _role =>
      _session.role.value ?? _session.user.value?.role ?? UserRole.orderBooker;

  String get _outboxRole =>
      _role == UserRole.deliveryMan ? 'deliveryMan' : 'orderBooker';

  String get _tagsPath => _role == UserRole.deliveryMan
      ? ApiEndpoints.dmReportsTags
      : ApiEndpoints.obReportsTags;

  String get _listPath => _role == UserRole.deliveryMan
      ? ApiEndpoints.dmReportsList
      : ApiEndpoints.obReportsList;

  String get _getPath => _role == UserRole.deliveryMan
      ? ApiEndpoints.dmReportsGet
      : ApiEndpoints.obReportsGet;

  Future<String> deviceInfoString() async {
    final cached = _deviceInfoCache;
    if (cached != null && cached.isNotEmpty) return cached;

    final app = _role == UserRole.deliveryMan ? 'ShahtajDM' : 'ShahtajOB';
    final build = AppBuildInfo.versionLabel;
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        final model = info.model.trim().isEmpty ? info.brand : info.model;
        final line = 'Android ${info.version.release} / $model / $app $build';
        _deviceInfoCache = line;
        return line;
      }
      if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        final line =
            'iOS ${info.systemVersion} / ${info.utsname.machine} / $app $build';
        _deviceInfoCache = line;
        return line;
      }
    } catch (_) {}

    final fallback =
        '${Platform.operatingSystem} ${Platform.operatingSystemVersion} / $app $build';
    _deviceInfoCache = fallback;
    return fallback;
  }

  Future<List<ReportTagModel>> fetchTags({bool force = false}) async {
    if (!force && _tagsMemory != null && _tagsMemory!.isNotEmpty) {
      return _tagsMemory!;
    }

    if (!_canReachServer) {
      final cached = await _cache.readMap(OfflineCacheKeys.reportTags);
      if (cached != null) {
        final tags = _parseTags(cached);
        _tagsMemory = tags;
        return tags;
      }
      return _tagsMemory ?? const [];
    }

    try {
      final data = await _api.postData(_tagsPath);
      await _cache.saveMap(OfflineCacheKeys.reportTags, data);
      final tags = _parseTags(data);
      _tagsMemory = tags;
      return tags;
    } catch (_) {
      final cached = await _cache.readMap(OfflineCacheKeys.reportTags);
      if (cached != null) {
        final tags = _parseTags(cached);
        _tagsMemory = tags;
        return tags;
      }
      rethrow;
    }
  }

  Future<ReportListResult> fetchMyReports({
    ReportState? state,
    int limit = 20,
    int offset = 0,
    bool forceNetwork = false,
  }) async {
    ReportListResult remote = const ReportListResult(count: 0, reports: []);

    final body = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (state != null) 'state': state.apiValue,
    };

    if (_canReachServer && (forceNetwork || offset == 0)) {
      try {
        final data = await _api.postData(_listPath, data: body);
        remote = ReportListResult.fromJson(data);
        if (offset == 0 && state == null) {
          await _cache.saveMap(OfflineCacheKeys.reportsList, data);
        }
      } catch (_) {
        if (offset == 0 && state == null) {
          final cached = await _cache.readMap(OfflineCacheKeys.reportsList);
          if (cached != null) remote = ReportListResult.fromJson(cached);
        } else if (forceNetwork) {
          rethrow;
        }
      }
    } else if (offset == 0) {
      final cached = await _cache.readMap(OfflineCacheKeys.reportsList);
      if (cached != null) {
        remote = ReportListResult.fromJson(cached);
        if (state != null) {
          remote = ReportListResult(
            count: remote.reports.where((r) => r.state == state).length,
            reports: remote.reports
                .where((r) => r.state == state)
                .toList(growable: false),
          );
        }
      }
    }

    if (offset != 0) return remote;

    final pending = await _pendingCreateSummaries();
    final filteredPending = state == null
        ? pending
        : pending.where((r) => r.state == state).toList(growable: false);

    if (filteredPending.isEmpty) return remote;

    final remoteIds = remote.reports.map((r) => r.reportId).toSet();
    final extras = filteredPending
        .where((r) => r.reportId < 0 || !remoteIds.contains(r.reportId))
        .toList(growable: false);

    return ReportListResult(
      count: remote.count + extras.length,
      reports: [...extras, ...remote.reports],
    );
  }

  Future<ReportSummaryModel> fetchReport({
    required int reportId,
    bool includeScreenshot = false,
  }) async {
    if (reportId < 0) {
      final pending = await _pendingCreateSummaries();
      final match = pending.where((r) => r.reportId == reportId).toList();
      if (match.isNotEmpty) return match.first;
      throw ApiException(message: AppTexts.emptyNotFoundTitle);
    }

    if (!_canReachServer) {
      final cached = await _cachedDetail(reportId);
      if (cached != null) return cached;
      throw ApiException(message: AppTexts.emptyNotFoundTitle);
    }

    try {
      final data = await _api.postData(
        _getPath,
        data: {'report_id': reportId, 'include_screenshot': includeScreenshot},
      );
      final report = ReportSummaryModel.fromJson(data);
      await _saveDetail(report);
      return report;
    } catch (_) {
      final cached = await _cachedDetail(reportId);
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<ReportSubmitResult> createReport({
    required String subject,
    required String description,
    required List<String> tagCodes,
    Uint8List? screenshotBytes,
  }) async {
    final payload = <String, dynamic>{
      'subject': subject.trim(),
      'description': description.trim(),
      'tag_codes': tagCodes,
      'device_info': await deviceInfoString(),
    };

    if (screenshotBytes != null && screenshotBytes.isNotEmpty) {
      final mediaId = await _media.save(
        screenshotBytes,
        purpose: 'report_create_screenshot',
      );
      payload['screenshot'] = OutboxPayload.mediaRef(mediaId);
    }

    final synced = await _outbox.enqueueAndFlush(
      role: _outboxRole,
      action: 'report_create',
      payload: payload,
      entityType: 'report',
    );

    await _cache.clearKeys([OfflineCacheKeys.reportsList]);

    if (synced) {
      try {
        final list = await fetchMyReports(forceNetwork: true);
        final match = list.reports.where(
          (r) =>
              r.subject == subject.trim() &&
              r.description == description.trim(),
        );
        return ReportSubmitResult(
          queued: false,
          report: match.isEmpty ? null : match.first,
        );
      } catch (_) {
        return const ReportSubmitResult(queued: false);
      }
    }

    return const ReportSubmitResult(queued: true);
  }

  List<ReportTagModel> _parseTags(Map<String, dynamic> data) {
    return ApiMap.listOf(
      data,
      'tags',
    ).map(ReportTagModel.fromJson).toList(growable: false);
  }

  Future<List<ReportSummaryModel>> _pendingCreateSummaries() async {
    final open = await _outbox.listPending();
    final tags = _tagsMemory ?? const <ReportTagModel>[];
    final result = <ReportSummaryModel>[];

    for (final entry in open) {
      if (entry.action != 'report_create') continue;
      if (entry.role != _outboxRole) continue;

      Map<String, dynamic> payload = const {};
      try {
        final decoded = jsonDecode(entry.payloadJson);
        if (decoded is Map) payload = Map<String, dynamic>.from(decoded);
      } catch (_) {}

      final codes = <String>[];
      final rawCodes = payload['tag_codes'];
      if (rawCodes is List) {
        for (final c in rawCodes) {
          final code = c?.toString();
          if (code != null && code.isNotEmpty) codes.add(code);
        }
      }

      final matchedTags = tags
          .where((t) => codes.contains(t.code))
          .toList(growable: false);

      result.add(
        ReportSummaryModel(
          reportId: _localIdForOutbox(entry.id),
          name: AppTexts.reportPendingSync,
          subject: ApiMap.asString(payload['subject']) ?? '',
          description: ApiMap.asString(payload['description']) ?? '',
          state: ReportState.isNew,
          tags: matchedTags,
          deviceInfo: ApiMap.asString(payload['device_info']),
          createDate: entry.createdAt,
          hasScreenshot: OutboxPayload.collectMediaIds(payload).isNotEmpty,
          pendingSync: true,
          outboxId: entry.id,
        ),
      );
    }

    return result;
  }

  static int _localIdForOutbox(String outboxId) {
    var hash = 0;
    for (final unit in outboxId.codeUnits) {
      hash = 0x1fffffff & (hash + unit);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & hash;
    hash += (0x03ffffff & hash) << 3;
    hash ^= hash >> 11;
    final positive = (hash & 0x7fffffff);
    return positive == 0 ? -1 : -positive;
  }

  Future<void> _saveDetail(ReportSummaryModel report) async {
    await _cache.saveMap(
      _detailKey(report.reportId),
      report.toJson(includeScreenshot: false),
    );
  }

  Future<ReportSummaryModel?> _cachedDetail(int reportId) async {
    final map = await _cache.readMap(_detailKey(reportId));
    if (map == null) return null;
    return ReportSummaryModel.fromJson(map);
  }

  String _detailKey(int reportId) => 'offline_cache_report_detail_$reportId';
}
