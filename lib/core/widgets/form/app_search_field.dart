import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_field_label.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_input_decoration.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon = const Icon(AppIcons.search, color: AppColors.grey),
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.inputFormatters,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _internal;

  @override
  void initState() {
    super.initState();
    _internal = TextEditingController(text: _readableText(widget.controller));
  }

  @override
  void didUpdateWidget(AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    final next = _readableText(widget.controller);
    if (_internal.text != next) {
      _internal.text = next;
    }
  }

  @override
  void dispose() {
    _internal.dispose();
    super.dispose();
  }

  String _readableText(TextEditingController? controller) {
    if (controller == null) return '';
    try {
      return controller.text;
    } catch (_) {
      return '';
    }
  }

  void _handleChanged(String value) {
    final external = widget.controller;
    if (external != null) {
      try {
        if (external.text != value) external.text = value;
      } catch (_) {}
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormFieldLabel(label: widget.label),
        AppSpacing.vertical(context, 0.01),
        TextFormField(
          controller: _internal,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          onChanged: _handleChanged,
          onFieldSubmitted: widget.onSubmitted,
          maxLines: widget.maxLines,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.readOnly,
          decoration: AppInputDecoration.decoration(
            context,
            hintText: widget.hint ?? AppTexts.search,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
          style: AppTextStyles.bodyText(context),
        ),
      ],
    );
  }
}
