import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker_mode.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker_sheet.dart';

class AppDateTimePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    String? title,
    DateTime? initial,
    DateTime? minDate,
    DateTime? maxDate,
    AppDateTimePickerMode mode = AppDateTimePickerMode.dateTime,
  }) async {
    final defaultTitle = switch (mode) {
      AppDateTimePickerMode.dateOnly => AppTexts.selectDate,
      AppDateTimePickerMode.timeOnly => AppTexts.selectTime,
      AppDateTimePickerMode.dateTime => AppTexts.selectDateTime,
    };
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => AppDateTimePickerSheet(
        title: title ?? defaultTitle,
        initial: initial ?? DateTime.now(),
        minDate: minDate,
        maxDate: maxDate,
        mode: mode,
      ),
    );
  }
}
