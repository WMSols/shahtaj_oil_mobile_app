class AppDateTimePickerUtils {
  AppDateTimePickerUtils._();

  static const daysToShow = 365 * 2;
  static const hourCount12 = 12;
  static const minuteCount = 60;
  static const periodCount = 2;

  static int hour24ToDisplayIndex(int hour24) {
    if (hour24 == 0 || hour24 == 12) return 0;
    return hour24 % 12;
  }

  static int displayIndexToHour24(int displayIndex, bool isPM) {
    if (isPM) return displayIndex == 0 ? 12 : displayIndex + 12;
    return displayIndex == 0 ? 0 : displayIndex;
  }
}
