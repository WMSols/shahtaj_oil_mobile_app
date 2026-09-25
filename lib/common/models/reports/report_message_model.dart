import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/text/app_plain_text.dart';

enum ReportThreadKind { user, office, status }

class ReportMessageModel {
  const ReportMessageModel({
    this.id,
    this.body,
    this.authorName,
    this.createdAt,
    this.hasScreenshot = false,
    this.isMine = false,
    this.isStatus = false,
    this.sortIndex = 0,
  });

  final int? id;
  final String? body;
  final String? authorName;
  final DateTime? createdAt;
  final bool hasScreenshot;
  final bool isMine;
  final bool isStatus;

  /// Original API order (stable fallback when timestamps collide / missing).
  final int sortIndex;

  ReportThreadKind get kind {
    if (isStatus) return ReportThreadKind.status;
    if (isMine) return ReportThreadKind.user;
    return ReportThreadKind.office;
  }

  factory ReportMessageModel.fromJson(
    Map<String, dynamic> json, {
    int sortIndex = 0,
  }) {
    final authorType =
        (ApiMap.asString(json['author_type']) ??
                ApiMap.asString(json['author_role']) ??
                ApiMap.asString(json['side']) ??
                '')
            .trim()
            .toLowerCase();
    final messageType =
        (ApiMap.asString(json['message_type']) ??
                ApiMap.asString(json['type']) ??
                ApiMap.asString(json['subtype']) ??
                '')
            .trim()
            .toLowerCase();

    final body = AppPlainText.fromHtml(
      ApiMap.asString(json['body']) ??
          ApiMap.asString(json['message']) ??
          ApiMap.asString(json['text']),
    );

    final flaggedStatus =
        json['is_status'] == true ||
        json['is_notification'] == true ||
        messageType.contains('notification') ||
        messageType.contains('status') ||
        messageType.contains('system') ||
        authorType == 'system' ||
        authorType == 'status';

    final isMine =
        json['is_mine'] == true ||
        json['from_reporter'] == true ||
        authorType == 'reporter' ||
        authorType == 'user' ||
        authorType == 'mobile' ||
        authorType == 'order_booker' ||
        authorType == 'delivery_man' ||
        authorType == 'field';

    return ReportMessageModel(
      id: ApiMap.asInt(json['id']) ?? ApiMap.asInt(json['message_id']),
      body: body,
      authorName:
          ApiMap.asString(json['author_name']) ??
          ApiMap.asString(json['reported_by']) ??
          ApiMap.asString(json['author']),
      createdAt:
          ApiMap.asDateTime(json['create_date']) ??
          ApiMap.asDateTime(json['created_at']) ??
          ApiMap.asDateTime(json['date']) ??
          ApiMap.asDateTime(json['write_date']) ??
          ApiMap.asDateTime(json['datetime']),
      hasScreenshot:
          json['has_screenshot'] == true ||
          (json['screenshot'] != null && json['screenshot'] != false),
      isMine: isMine && !flaggedStatus,
      isStatus: flaggedStatus || AppPlainText.looksLikeStatusEvent(body),
      sortIndex: sortIndex,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (body != null) 'body': body,
    if (authorName != null) 'author_name': authorName,
    if (createdAt != null) 'create_date': createdAt!.toIso8601String(),
    'has_screenshot': hasScreenshot,
    'is_mine': isMine,
    'is_status': isStatus,
  };

  ReportMessageModel copyWith({
    int? id,
    String? body,
    String? authorName,
    DateTime? createdAt,
    bool? hasScreenshot,
    bool? isMine,
    bool? isStatus,
    int? sortIndex,
  }) => ReportMessageModel(
    id: id ?? this.id,
    body: body ?? this.body,
    authorName: authorName ?? this.authorName,
    createdAt: createdAt ?? this.createdAt,
    hasScreenshot: hasScreenshot ?? this.hasScreenshot,
    isMine: isMine ?? this.isMine,
    isStatus: isStatus ?? this.isStatus,
    sortIndex: sortIndex ?? this.sortIndex,
  );
}
