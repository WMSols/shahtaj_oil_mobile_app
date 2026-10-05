import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';

/// How [AppText] transforms its string before painting.
///
/// Casings live here (not in [TextStyle]) so chrome widgets stay free of
/// per-call `AppFormatter.titleCase` / `.toUpperCase()` boilerplate.
enum AppTextCasing {
  /// Leave the string unchanged (body copy, hints, values).
  none,

  /// Title Case for labels, titles, button text, API display names.
  title,

  /// ALL CAPS for status / filter chips.
  upper,
}

/// App-wide [Text] with optional casing.
///
/// Prefer named constructors:
/// - [AppText.label] — Title Case (buttons, headers, shop/product names)
/// - [AppText.upper] — ALL CAPS (status / filter chips)
/// - [AppText] / [AppText.plain] — no transform (body, hints, codes)
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.casing = AppTextCasing.none,
  });

  const AppText.plain(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
  }) : casing = AppTextCasing.none;

  const AppText.label(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
  }) : casing = AppTextCasing.title;

  const AppText.upper(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
  }) : casing = AppTextCasing.upper;

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final AppTextCasing casing;

  String get _resolved => switch (casing) {
    AppTextCasing.none => data,
    AppTextCasing.title => AppFormatter.titleCase(data),
    AppTextCasing.upper => data.toUpperCase(),
  };

  @override
  Widget build(BuildContext context) {
    return Text(
      _resolved,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }
}
