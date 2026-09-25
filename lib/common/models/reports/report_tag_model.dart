import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class ReportTagModel {
  const ReportTagModel({
    required this.tagId,
    required this.name,
    required this.code,
    this.kind,
  });

  final int tagId;
  final String name;
  final String code;
  final String? kind;

  factory ReportTagModel.fromJson(Map<String, dynamic> json) => ReportTagModel(
    tagId: ApiMap.asInt(json['tag_id']) ?? ApiMap.asInt(json['id']) ?? 0,
    name: ApiMap.asString(json['name']) ?? '',
    code: ApiMap.asString(json['code']) ?? '',
    kind: ApiMap.asString(json['kind']),
  );

  Map<String, dynamic> toJson() => {
    'tag_id': tagId,
    'name': name,
    'code': code,
    if (kind != null) 'kind': kind,
  };
}
