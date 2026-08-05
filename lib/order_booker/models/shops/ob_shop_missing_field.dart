import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

/// Dynamic first-visit field descriptor from `missing_fields`.
class ObShopMissingField {
  const ObShopMissingField({
    required this.key,
    required this.label,
    this.required = false,
    this.type = 'string',
    this.source = 'form',
  });

  final String key;
  final String label;
  final bool required;
  final String type;
  final String source;

  bool get isImage => type == 'image';
  bool get isGps =>
      source == 'device_gps' || key == 'latitude' || key == 'longitude';
  bool get isForm => source == 'form' || type == 'string';

  factory ObShopMissingField.fromJson(Map<String, dynamic> json) {
    return ObShopMissingField(
      key: ApiMap.asString(json['key']) ?? '',
      label:
          ApiMap.asString(json['label']) ?? ApiMap.asString(json['key']) ?? '',
      required: json['required'] == true,
      type: ApiMap.asString(json['type'])?.toLowerCase() ?? 'string',
      source: ApiMap.asString(json['source'])?.toLowerCase() ?? 'form',
    );
  }

  static List<ObShopMissingField> listFrom(dynamic raw) {
    if (raw is! List) return const [];
    final fields = <ObShopMissingField>[];
    for (final item in raw) {
      final map = ApiMap.asMap(item);
      if (map != null) fields.add(ObShopMissingField.fromJson(map));
    }
    return fields;
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'label': label,
    'required': required,
    'type': type,
    'source': source,
  };
}
