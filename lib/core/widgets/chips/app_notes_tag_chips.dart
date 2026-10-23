import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/notes_tag_catalog.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_form_field_label.dart';

/// Optional single-select quick tags for notes fields (no backend).
class AppNotesTagChips extends StatelessWidget {
  const AppNotesTagChips({
    super.key,
    required this.contextType,
    required this.selectedLabel,
    required this.onSelected,
  });

  final NotesTagContext contextType;
  final String? selectedLabel;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tags = NotesTagCatalog.labelsFor(contextType);
    if (tags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppFormFieldLabel(label: AppTexts.notesQuickTagsLabel),
        AppSpacing.vertical(context, 0.008),
        Wrap(
          runSpacing: AppSpacing.verticalValue(context, 0.006),
          children: [
            for (final tag in tags)
              AppFilterChip(
                label: tag,
                selected: selectedLabel == tag,
                uppercase: false,
                onTap: () => onSelected(tag),
              ),
          ],
        ),
      ],
    );
  }
}
