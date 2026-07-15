import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_text_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker_mode.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker_utils.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_picker_wheel.dart';

class AppDateTimePickerSheet extends StatefulWidget {
  const AppDateTimePickerSheet({
    super.key,
    required this.title,
    required this.initial,
    required this.mode,
    this.minDate,
    this.maxDate,
  });

  final String title;
  final DateTime initial;
  final AppDateTimePickerMode mode;
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  State<AppDateTimePickerSheet> createState() => AppDateTimePickerSheetState();
}

class AppDateTimePickerSheetState extends State<AppDateTimePickerSheet> {
  late DateTime selected;
  late FixedExtentScrollController dateController;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController periodController;

  bool get showDate =>
      widget.mode == AppDateTimePickerMode.dateOnly ||
      widget.mode == AppDateTimePickerMode.dateTime;

  bool get showTime =>
      widget.mode == AppDateTimePickerMode.timeOnly ||
      widget.mode == AppDateTimePickerMode.dateTime;

  @override
  void initState() {
    super.initState();
    selected = _clampToBounds(widget.initial);
    final list = dates;
    var dateIndex = 0;
    if (list.isNotEmpty) {
      final d0 = DateTime(selected.year, selected.month, selected.day);
      dateIndex = list.indexWhere(
        (d) => d.year == d0.year && d.month == d0.month && d.day == d0.day,
      );
      if (dateIndex < 0) dateIndex = 0;
    }
    dateController = FixedExtentScrollController(initialItem: dateIndex);
    hourController = FixedExtentScrollController(
      initialItem: AppDateTimePickerUtils.hour24ToDisplayIndex(
        selected.hour.clamp(0, 23),
      ),
    );
    minuteController = FixedExtentScrollController(
      initialItem: selected.minute.clamp(0, 59),
    );
    periodController = FixedExtentScrollController(
      initialItem: selected.hour < 12 ? 0 : 1,
    );
  }

  DateTime _clampToBounds(DateTime value) {
    var next = value;
    final min = widget.minDate;
    final max = widget.maxDate;
    if (min != null) {
      final minDay = DateTime(min.year, min.month, min.day);
      final day = DateTime(next.year, next.month, next.day);
      if (day.isBefore(minDay)) {
        next = DateTime(
          minDay.year,
          minDay.month,
          minDay.day,
          next.hour,
          next.minute,
        );
      }
    }
    if (max != null) {
      final maxDay = DateTime(max.year, max.month, max.day);
      final day = DateTime(next.year, next.month, next.day);
      if (day.isAfter(maxDay)) {
        next = DateTime(
          maxDay.year,
          maxDay.month,
          maxDay.day,
          next.hour,
          next.minute,
        );
      }
    }
    return next;
  }

  DateTime resultForMode() {
    final clamped = _clampToBounds(selected);
    if (widget.mode == AppDateTimePickerMode.dateOnly) {
      return DateTime(clamped.year, clamped.month, clamped.day);
    }
    return clamped;
  }

  @override
  void dispose() {
    dateController.dispose();
    hourController.dispose();
    minuteController.dispose();
    periodController.dispose();
    super.dispose();
  }

  List<DateTime> get dates {
    final now = DateTime.now();
    final defaultStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 365));
    final startRaw = widget.minDate ?? defaultStart;
    final start = DateTime(startRaw.year, startRaw.month, startRaw.day);

    final defaultEnd = start.add(
      Duration(days: AppDateTimePickerUtils.daysToShow - 1),
    );
    final endRaw = widget.maxDate ?? defaultEnd;
    var end = DateTime(endRaw.year, endRaw.month, endRaw.day);
    if (end.isBefore(start)) end = start;

    final count = end.difference(start).inDays + 1;
    return List.generate(count, (i) => start.add(Duration(days: i)));
  }

  void onDateIndexChanged(int index) {
    final list = dates;
    if (index < 0 || index >= list.length) return;
    final d = list[index];
    setState(() {
      selected = DateTime(
        d.year,
        d.month,
        d.day,
        selected.hour,
        selected.minute,
      );
    });
  }

  void onHourChanged(int displayIndex) {
    final isPM = selected.hour >= 12;
    final hour24 = AppDateTimePickerUtils.displayIndexToHour24(
      displayIndex.clamp(0, 11),
      isPM,
    );
    setState(() {
      selected = DateTime(
        selected.year,
        selected.month,
        selected.day,
        hour24,
        selected.minute,
      );
    });
  }

  void onPeriodChanged(int periodIndex) {
    final displayIndex = AppDateTimePickerUtils.hour24ToDisplayIndex(
      selected.hour,
    );
    final hour24 = AppDateTimePickerUtils.displayIndexToHour24(
      displayIndex,
      periodIndex == 1,
    );
    setState(() {
      selected = DateTime(
        selected.year,
        selected.month,
        selected.day,
        hour24,
        selected.minute,
      );
    });
  }

  void onMinuteChanged(int minute) {
    setState(() {
      selected = DateTime(
        selected.year,
        selected.month,
        selected.day,
        selected.hour,
        minute.clamp(0, 59),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppResponsive.scaleSize(context, 20)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextButton(
                    label: AppTexts.cancel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    widget.title,
                    style: AppTextStyles.bodyText(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  AppTextButton(
                    label: AppTexts.save,
                    onPressed: () => Navigator.of(context).pop(resultForMode()),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SizedBox(
              height: AppSpacing.verticalValue(context, 0.25),
              child: Row(
                children: [
                  if (showDate)
                    Expanded(
                      flex: showTime ? 1 : 2,
                      child: ListWheelScrollView.useDelegate(
                        controller: dateController,
                        itemExtent: AppResponsive.scaleSize(context, 44),
                        diameterRatio: 1.2,
                        perspective: 0.003,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: onDateIndexChanged,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: dates.length,
                          builder: (context, index) {
                            final d = dates[index];
                            final isSelected =
                                d.year == selected.year &&
                                d.month == selected.month &&
                                d.day == selected.day;
                            return Center(
                              child: AppPickerWheelLabel(
                                text: AppFormatter.shortDate(d),
                                selected: isSelected,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  if (showTime)
                    Expanded(
                      flex: showDate ? 1 : 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppPickerWheel(
                            controller: hourController,
                            count: AppDateTimePickerUtils.hourCount12,
                            onChanged: onHourChanged,
                            itemBuilder: (context, index) {
                              final label = index == 0
                                  ? '12'
                                  : index.toString();
                              final isSelected =
                                  index ==
                                  AppDateTimePickerUtils.hour24ToDisplayIndex(
                                    selected.hour,
                                  );
                              return AppPickerWheelLabel(
                                text: label,
                                selected: isSelected,
                              );
                            },
                          ),
                          Text(
                            ':',
                            style: AppTextStyles.bodyText(
                              context,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                          AppPickerWheel(
                            controller: minuteController,
                            count: AppDateTimePickerUtils.minuteCount,
                            onChanged: onMinuteChanged,
                            itemBuilder: (context, index) {
                              return AppPickerWheelLabel(
                                text: index.toString().padLeft(2, '0'),
                                selected: index == selected.minute,
                              );
                            },
                          ),
                          AppPickerWheel(
                            controller: periodController,
                            count: AppDateTimePickerUtils.periodCount,
                            onChanged: onPeriodChanged,
                            itemBuilder: (context, index) {
                              final label = index == 0
                                  ? AppTexts.periodAm
                                  : AppTexts.periodPm;
                              final isSelected =
                                  (index == 0 && selected.hour < 12) ||
                                  (index == 1 && selected.hour >= 12);
                              return AppPickerWheelLabel(
                                text: label,
                                selected: isSelected,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            AppSpacing.vertical(context, 0.02),
          ],
        ),
      ),
    );
  }
}
