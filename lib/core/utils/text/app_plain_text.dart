/// Lightweight HTML → plain text for API message bodies (Odoo-style `<p>` etc.).
abstract class AppPlainText {
  AppPlainText._();

  static String fromHtml(String? raw) {
    if (raw == null) return '';
    var text = raw.trim();
    if (text.isEmpty) return '';

    text = text
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</div\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<li[^>]*>', caseSensitive: false), '• ')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'[ \t]+\n'), '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r'[ \t]{2,}'), ' ')
        .trim();

    return text;
  }

  static bool looksLikeCreateNotice(String? raw) {
    final normalized = _normalize(raw);
    if (normalized.isEmpty) return false;
    return normalized.contains('report created') ||
        normalized.contains('created from mobile') ||
        normalized.contains('field / app report') ||
        normalized == 'report submitted';
  }

  /// System / WhatsApp-style status lines from the distributor panel.
  static bool looksLikeStatusEvent(String? raw) {
    final normalized = _normalize(raw);
    if (normalized.isEmpty) return false;
    if (looksLikeCreateNotice(normalized)) return true;
    if (normalized.contains('(status)')) return true;
    if (RegExp(r'(→|->|—>)').hasMatch(normalized) &&
        (normalized.contains('new') ||
            normalized.contains('progress') ||
            normalized.contains('done') ||
            normalized.contains('cancel'))) {
      return true;
    }
    return false;
  }

  static String _normalize(String? raw) =>
      fromHtml(raw).toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
}
