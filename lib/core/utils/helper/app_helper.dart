class AppHelper {
  AppHelper._();

  static DateTime? parseDateTimeOrNull(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final s = value.trim();
    final dt = DateTime.tryParse(s);
    if (dt != null) return dt;
    final parts = s.split('-');
    if (parts.length >= 3) {
      final y = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2].split('T').first.split(' ').first);
      if (y != null && m != null && d != null) {
        return DateTime(y, m, d);
      }
    }
    return null;
  }

  static bool isNullOrEmpty(String? value) =>
      value == null || value.trim().isEmpty;

  static bool isNotNullOrEmpty(String? value) => !isNullOrEmpty(value);

  static List<String> parseCommaSeparatedList(String? value) {
    if (value == null || value.trim().isEmpty) return const [];
    return value
        .trim()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Returns up to two uppercase initials from [name].
  /// Example: "Mubeen Bhatti" → "MB", "Ali" → "A".
  static String initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      return word.length == 1
          ? word.toUpperCase()
          : word.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  static String truncateText(String text, {int maxLength = 80}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }
}

extension StringHelperExtension on String? {
  bool get isNullOrEmpty => AppHelper.isNullOrEmpty(this);
  bool get isNotNullOrEmpty => AppHelper.isNotNullOrEmpty(this);
}
