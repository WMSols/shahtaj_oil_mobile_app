class ApiMap {
  ApiMap._();

  static Map<String, dynamic>? asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static List<Map<String, dynamic>> asMapList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map(asMap)
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
  }

  static List<Map<String, dynamic>> listOf(
    Map<String, dynamic> json,
    String key,
  ) => asMapList(json[key]);

  static int? asInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is bool) return null;
    return int.tryParse(value?.toString() ?? '');
  }

  static double? asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static String? asString(dynamic value) {
    if (value == null || value is bool) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? asDateTime(dynamic value) {
    final text = asString(value);
    if (text == null) return null;
    final parsed = DateTime.tryParse(text);
    if (parsed == null) return null;
    // Always expose device-local time. API/Odoo timestamps are UTC; naive
    // strings without Z/offset are treated as UTC wall-clock (PKT is UTC+5,
    // so formatting UTC components looked ~5 hours behind).
    if (parsed.isUtc) return parsed.toLocal();
    if (!_hasExplicitTimezone(text)) {
      return DateTime.utc(
        parsed.year,
        parsed.month,
        parsed.day,
        parsed.hour,
        parsed.minute,
        parsed.second,
        parsed.millisecond,
        parsed.microsecond,
      ).toLocal();
    }
    return parsed.toLocal();
  }

  static bool _hasExplicitTimezone(String text) {
    final trimmed = text.trim();
    if (trimmed.endsWith('Z') || trimmed.endsWith('z')) return true;
    return RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(trimmed);
  }

  static String snakeToCamel(String value) {
    if (!value.contains('_')) return value;
    final parts = value.split('_');
    return parts.first +
        parts.skip(1).map((part) {
          if (part.isEmpty) return '';
          return part[0].toUpperCase() + part.substring(1);
        }).join();
  }
}
