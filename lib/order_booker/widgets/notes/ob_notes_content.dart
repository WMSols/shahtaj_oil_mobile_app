import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';

class ObNotesContent extends StatelessWidget {
  const ObNotesContent({
    super.key,
    required this.notesController,
    required this.hint,
    required this.confirmLabel,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  final TextEditingController notesController;
  final String hint;
  final String confirmLabel;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.horizontalValue(context, 0.04),
        vertical: AppSpacing.verticalValue(context, 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AppTextField(
                controller: notesController,
                hint: hint,
                maxLines: 8,
                borderless: true,
              ),
            ),
          ),
          AppSpacing.vertical(context, 0.016),
          AppPrimaryButton(
            label: confirmLabel,
            isLoading: isSaving,
            onPressed: isSaving ? null : onSave,
          ),
          AppSpacing.vertical(context, 0.008),
          AppSecondaryButton(
            label: AppTexts.cancel,
            outlinedOnly: true,
            onPressed: isSaving ? null : onCancel,
          ),
        ],
      ),
    );
  }
}
