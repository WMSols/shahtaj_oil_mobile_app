import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';

/// Display formatting and shared input formatters.
/// For parsing use [AppHelper]; for validation use [AppValidator].
class AppFormatter {
  AppFormatter._();

  static String dateTime(DateTime timestamp) {
    final local = timestamp.toLocal();
    final datePart = DateFormat('EEE MMM dd yyyy').format(local);
    final timePart = DateFormat('h:mm a').format(local);
    return '$datePart - $timePart';
  }

  static String viewDetailDateTime(DateTime d) {
    final local = d.toLocal();
    final datePart = DateFormat('d MMM, yyyy').format(local);
    final timePart = DateFormat('hh:mm:ss a').format(local);
    return '$datePart $timePart';
  }

  static String dayMonthYear(DateTime d) {
    final months = [
      AppTexts.monJan,
      AppTexts.monFeb,
      AppTexts.monMar,
      AppTexts.monApr,
      AppTexts.monMay,
      AppTexts.monJun,
      AppTexts.monJul,
      AppTexts.monAug,
      AppTexts.monSep,
      AppTexts.monOct,
      AppTexts.monNov,
      AppTexts.monDec,
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static String timeOfDay(DateTime d) =>
      DateFormat('h:mm a').format(d.toLocal());

  static String shortDate(DateTime d) {
    final local = d.toLocal();
    final months = [
      AppTexts.monJan,
      AppTexts.monFeb,
      AppTexts.monMar,
      AppTexts.monApr,
      AppTexts.monMay,
      AppTexts.monJun,
      AppTexts.monJul,
      AppTexts.monAug,
      AppTexts.monSep,
      AppTexts.monOct,
      AppTexts.monNov,
      AppTexts.monDec,
    ];
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }

  static String dayNameFull(int weekday) {
    final names = [
      AppTexts.dayMonday,
      AppTexts.dayTuesday,
      AppTexts.dayWednesday,
      AppTexts.dayThursday,
      AppTexts.dayFriday,
      AppTexts.daySaturday,
      AppTexts.daySunday,
    ];
    return names[weekday - 1];
  }

  static String monthNameFull(int month) {
    final names = [
      AppTexts.monthJanuary,
      AppTexts.monthFebruary,
      AppTexts.monthMarch,
      AppTexts.monthApril,
      AppTexts.monthMay,
      AppTexts.monthJune,
      AppTexts.monthJuly,
      AppTexts.monthAugust,
      AppTexts.monthSeptember,
      AppTexts.monthOctober,
      AppTexts.monthNovember,
      AppTexts.monthDecember,
    ];
    return names[month - 1];
  }

  static String timeOfDayGreeting([DateTime? when]) {
    final hour = (when ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 12) return AppTexts.greetingMorning;
    if (hour >= 12 && hour < 17) return AppTexts.greetingAfternoon;
    if (hour >= 17 && hour < 21) return AppTexts.greetingEvening;
    return AppTexts.greetingNight;
  }

  static String dayNameShort(int weekday) {
    final names = [
      AppTexts.dayMon,
      AppTexts.dayTue,
      AppTexts.dayWed,
      AppTexts.dayThu,
      AppTexts.dayFri,
      AppTexts.daySat,
      AppTexts.daySun,
    ];
    return names[weekday - 1];
  }

  static String apiDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }

  static String apiDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final second = local.second.toString().padLeft(2, '0');
    return '${local.year}-$month-$day'
        'T$hour:$minute:$second';
  }

  static DateTime? parseApiDateTime(dynamic raw) {
    if (raw is DateTime) return raw.toLocal();
    return ApiMap.asDateTime(raw);
  }

  static String capitalizeFirstLetter(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }

  static String currency(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat('#,##0.00');
    return '$symbol${formatter.format(amount)}';
  }

  /// Whole-number currency — e.g. 50000 → `Rs 50,000`.
  static String currencyWhole(num amount, {String symbol = 'Rs. '}) {
    final formatter = NumberFormat('#,##0');
    return '$symbol${formatter.format(amount)}';
  }

  static String coordinates(double latitude, double longitude) {
    final latDir = latitude >= 0 ? 'N' : 'S';
    final lngDir = longitude >= 0 ? 'E' : 'W';
    return '${latitude.abs().toStringAsFixed(4)}° $latDir, '
        '${longitude.abs().toStringAsFixed(4)}° $lngDir';
  }

  /// Compact currency for dashboards — e.g. 45000 → `Rs 45K`.
  static String compactCurrency(num amount, {String symbol = 'Rs. '}) {
    final value = amount.toDouble().abs();
    final prefix = amount < 0 ? '-' : '';

    if (value >= 1000000) {
      return '$prefix$symbol${_compactNumber(value / 1000000)}M';
    }
    if (value >= 1000) {
      return '$prefix$symbol${_compactNumber(value / 1000)}K';
    }
    return '$prefix$symbol${value.toInt()}';
  }

  static String _compactNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  static String compactCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  static String invoiceNumber(String id) => 'INV-${id.padLeft(6, '0')}';

  static String displayDate(String? rawDate) {
    final parsed = AppHelper.parseDateTimeOrNull(rawDate);
    if (parsed == null) return rawDate?.trim() ?? '';
    return dayMonthYear(parsed);
  }

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return AppTexts.minsAgo(1);
    if (diff.inMinutes < 60) return AppTexts.minsAgo(diff.inMinutes);
    if (diff.inHours < 24) return AppTexts.hrsAgo(diff.inHours);
    return AppTexts.daysAgo(diff.inDays);
  }

  static String notificationTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.isNegative) return AppTexts.daysAgo(1);
    return timeAgo(dt);
  }

  static String notificationGroupDate(DateTime d) {
    final months = [
      AppTexts.monthJanuary,
      AppTexts.monthFebruary,
      AppTexts.monthMarch,
      AppTexts.monthApril,
      AppTexts.monthMay,
      AppTexts.monthJune,
      AppTexts.monthJuly,
      AppTexts.monthAugust,
      AppTexts.monthSeptember,
      AppTexts.monthOctober,
      AppTexts.monthNovember,
      AppTexts.monthDecember,
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

/// Formats Pakistan CNIC as `#####-#######-#` while typing.
class PakistanCnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 13 ? digits.substring(0, 13) : digits;

    final buffer = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      if (i == 5 || i == 12) buffer.write('-');
      buffer.write(limited[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats local Pakistan mobile as `300 XXXXXXX` (10 digits, space after first 3).
class PakistanPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 10 ? digits.substring(0, 10) : digits;

    final formatted = limited.length <= 3
        ? limited
        : '${limited.substring(0, 3)} ${limited.substring(3)}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
