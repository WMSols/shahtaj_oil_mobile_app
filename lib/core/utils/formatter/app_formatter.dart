import 'package:intl/intl.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';

/// Display formatting only. For parsing use [AppHelper]; for validation use [AppValidator].
class AppFormatter {
  AppFormatter._();

  static String dateTime(DateTime timestamp) {
    final datePart = DateFormat('EEE MMM dd yyyy').format(timestamp);
    final timePart = DateFormat('h:mm a').format(timestamp);
    return '$datePart - $timePart';
  }

  static String viewDetailDateTime(DateTime d) {
    final datePart = DateFormat('d MMM, yyyy').format(d);
    final timePart = DateFormat('hh:mm:ss a').format(d);
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

  static String timeOfDay(DateTime d) => DateFormat('h:mm a').format(d);

  static String shortDate(DateTime d) {
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
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
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is! String || raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw);
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
