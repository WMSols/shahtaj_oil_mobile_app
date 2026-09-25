import 'package:shahtaj_oil_mobile_app/common/models/reports/report_message_model.dart';
import 'package:shahtaj_oil_mobile_app/common/models/reports/report_tag_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ReportSummaryModel {
  const ReportSummaryModel({
    required this.reportId,
    required this.name,
    required this.subject,
    required this.description,
    required this.state,
    this.tags = const [],
    this.reportedBy,
    this.reportedById,
    this.reporterRole,
    this.hasScreenshot = false,
    this.screenshot,
    this.deviceInfo,
    this.createDate,
    this.closedAt,
    this.closingRemark,
    this.messages = const [],
    this.pendingSync = false,
    this.outboxId,
  });

  final int reportId;
  final String name;
  final String subject;
  final String description;
  final ReportState state;
  final List<ReportTagModel> tags;
  final String? reportedBy;
  final int? reportedById;
  final String? reporterRole;
  final bool hasScreenshot;
  final String? screenshot;
  final String? deviceInfo;
  final DateTime? createDate;
  final DateTime? closedAt;
  final String? closingRemark;
  final List<ReportMessageModel> messages;
  final bool pendingSync;
  final String? outboxId;

  bool get isLocalPending => pendingSync || reportId < 0;

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) {
    final closedRaw = json['closed_at'];
    DateTime? closedAt;
    if (closedRaw is String && closedRaw.trim().isNotEmpty) {
      closedAt = ApiMap.asDateTime(closedRaw);
    } else if (closedRaw is bool && closedRaw) {
      closedAt = null;
    }

    final tagsJson = ApiMap.asMapList(json['tags']);
    final messagesJson = ApiMap.asMapList(json['messages']);

    return ReportSummaryModel(
      reportId:
          ApiMap.asInt(json['report_id']) ?? ApiMap.asInt(json['id']) ?? 0,
      name: ApiMap.asString(json['name']) ?? '',
      subject: ApiMap.asString(json['subject']) ?? '',
      description: ApiMap.asString(json['description']) ?? '',
      state: ReportStateX.fromApi(json['state']),
      tags: tagsJson.map(ReportTagModel.fromJson).toList(growable: false),
      reportedBy: ApiMap.asString(json['reported_by']),
      reportedById: ApiMap.asInt(json['reported_by_id']),
      reporterRole: ApiMap.asString(json['reporter_role']),
      hasScreenshot: json['has_screenshot'] == true,
      screenshot: ApiMap.asString(json['screenshot']),
      deviceInfo: ApiMap.asString(json['device_info']),
      createDate:
          ApiMap.asDateTime(json['create_date']) ??
          ApiMap.asDateTime(json['created_at']),
      closedAt: closedAt,
      closingRemark: ApiMap.asString(json['closing_remark']),
      messages: [
        for (var i = 0; i < messagesJson.length; i++)
          ReportMessageModel.fromJson(messagesJson[i], sortIndex: i),
      ],
      pendingSync: json['pending_sync'] == true,
      outboxId: ApiMap.asString(json['outbox_id']),
    );
  }

  Map<String, dynamic> toJson({bool includeScreenshot = false}) => {
    'report_id': reportId,
    'name': name,
    'subject': subject,
    'description': description,
    'state': state.apiValue,
    'tags': tags.map((t) => t.toJson()).toList(growable: false),
    if (reportedBy != null) 'reported_by': reportedBy,
    if (reportedById != null) 'reported_by_id': reportedById,
    if (reporterRole != null) 'reporter_role': reporterRole,
    'has_screenshot': hasScreenshot,
    if (includeScreenshot && screenshot != null) 'screenshot': screenshot,
    if (deviceInfo != null) 'device_info': deviceInfo,
    if (createDate != null) 'create_date': createDate!.toIso8601String(),
    'closed_at': closedAt?.toIso8601String() ?? false,
    if (closingRemark != null) 'closing_remark': closingRemark,
    'messages': messages.map((m) => m.toJson()).toList(growable: false),
    'pending_sync': pendingSync,
    if (outboxId != null) 'outbox_id': outboxId,
  };

  ReportSummaryModel copyWith({
    int? reportId,
    String? name,
    String? subject,
    String? description,
    ReportState? state,
    List<ReportTagModel>? tags,
    String? reportedBy,
    int? reportedById,
    String? reporterRole,
    bool? hasScreenshot,
    String? screenshot,
    String? deviceInfo,
    DateTime? createDate,
    DateTime? closedAt,
    String? closingRemark,
    List<ReportMessageModel>? messages,
    bool? pendingSync,
    String? outboxId,
  }) => ReportSummaryModel(
    reportId: reportId ?? this.reportId,
    name: name ?? this.name,
    subject: subject ?? this.subject,
    description: description ?? this.description,
    state: state ?? this.state,
    tags: tags ?? this.tags,
    reportedBy: reportedBy ?? this.reportedBy,
    reportedById: reportedById ?? this.reportedById,
    reporterRole: reporterRole ?? this.reporterRole,
    hasScreenshot: hasScreenshot ?? this.hasScreenshot,
    screenshot: screenshot ?? this.screenshot,
    deviceInfo: deviceInfo ?? this.deviceInfo,
    createDate: createDate ?? this.createDate,
    closedAt: closedAt ?? this.closedAt,
    closingRemark: closingRemark ?? this.closingRemark,
    messages: messages ?? this.messages,
    pendingSync: pendingSync ?? this.pendingSync,
    outboxId: outboxId ?? this.outboxId,
  );
}

class ReportListResult {
  const ReportListResult({required this.count, required this.reports});

  final int count;
  final List<ReportSummaryModel> reports;

  factory ReportListResult.fromJson(Map<String, dynamic> json) {
    final reports = ApiMap.asMapList(
      json['reports'],
    ).map(ReportSummaryModel.fromJson).toList(growable: false);
    return ReportListResult(
      count: ApiMap.asInt(json['count']) ?? reports.length,
      reports: reports,
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'reports': reports.map((r) => r.toJson()).toList(growable: false),
  };
}
