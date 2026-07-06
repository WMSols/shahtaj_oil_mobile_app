import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';

class ObTaskNotesSheet extends StatefulWidget {
  const ObTaskNotesSheet({
    super.key,
    required this.initialNotes,
    required this.onSave,
  });

  final String? initialNotes;
  final Future<void> Function(String notes) onSave;

  @override
  State<ObTaskNotesSheet> createState() => _ObTaskNotesSheetState();
}

class _ObTaskNotesSheetState extends State<ObTaskNotesSheet> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await widget.onSave(_controller.text);
      if (mounted) Get.back();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.horizontalValue(context, 0.04),
          right: AppSpacing.horizontalValue(context, 0.04),
          top: AppSpacing.verticalValue(context, 0.02),
          bottom:
              MediaQuery.viewInsetsOf(context).bottom +
              AppSpacing.verticalValue(context, 0.02),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppTexts.obTaskNotes, style: AppTextStyles.heading(context)),
            AppSpacing.vertical(context, 0.012),
            AppTextField(
              controller: _controller,
              hint: AppTexts.obTaskNotesHint,
              maxLines: 4,
              borderless: true,
            ),
            AppSpacing.vertical(context, 0.016),
            AppPrimaryButton(
              label: AppTexts.save,
              isLoading: _isSaving,
              onPressed: _isSaving ? null : _save,
            ),
            AppSpacing.vertical(context, 0.008),
            AppSecondaryButton(
              label: AppTexts.cancel,
              outlinedOnly: true,
              onPressed: _isSaving ? null : Get.back,
            ),
          ],
        ),
      ),
    );
  }
}
