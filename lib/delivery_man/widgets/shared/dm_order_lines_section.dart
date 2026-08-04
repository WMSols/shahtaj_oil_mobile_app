import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_order_line_model.dart';

class DmOrderLinesSection extends StatelessWidget {
  const DmOrderLinesSection({
    super.key,
    required this.lines,
    this.editable = false,
    this.deliveredDrafts,
    this.rejectedDrafts,
    this.onDeliveredChanged,
    this.onRejectedChanged,
  });

  final List<DmOrderLineModel> lines;
  final bool editable;
  final Map<String, String>? deliveredDrafts;
  final Map<String, String>? rejectedDrafts;
  final void Function(String lineId, String raw)? onDeliveredChanged;
  final void Function(String lineId, String raw)? onRejectedChanged;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.dmOrderLinesSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.008),
        ...lines.map(
          (line) => Padding(
            padding: EdgeInsets.only(
              bottom: AppSpacing.verticalValue(context, 0.01),
            ),
            child: _LineCard(
              line: line,
              editable: editable,
              deliveredText: deliveredDrafts?[line.id],
              rejectedText: rejectedDrafts?[line.id],
              onDeliveredChanged: onDeliveredChanged,
              onRejectedChanged: onRejectedChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _LineCard extends StatelessWidget {
  const _LineCard({
    required this.line,
    required this.editable,
    this.deliveredText,
    this.rejectedText,
    this.onDeliveredChanged,
    this.onRejectedChanged,
  });

  final DmOrderLineModel line;
  final bool editable;
  final String? deliveredText;
  final String? rejectedText;
  final void Function(String lineId, String raw)? onDeliveredChanged;
  final void Function(String lineId, String raw)? onRejectedChanged;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      color: AppColors.grey.withValues(alpha: 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(line.productName, style: AppTextStyles.sectionTitle(context)),
          AppSpacing.vertical(context, 0.006),
          Text(
            '${AppTexts.dmOrderedQty}: ${_fmt(line.orderedQty)} · '
            '${AppTexts.dmLoadedQty}: ${_fmt(line.loadedQty)} · '
            '${AppFormatter.currencyWhole(line.unitPrice)}',
            style: AppTextStyles.caption(context),
          ),
          if (!editable) ...[
            AppSpacing.vertical(context, 0.006),
            Text(
              '${AppTexts.dmDeliveredQty}: ${_fmt(line.deliveredQty)} · '
              '${AppTexts.dmRejectedQty}: ${_fmt(line.rejectedQty)} · '
              '${AppTexts.dmLeftoverQty}: ${_fmt(line.leftoverQty)}',
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            AppSpacing.vertical(context, 0.01),
            _QtyField(
              label: AppTexts.dmDeliveredQty,
              value: deliveredText ?? '',
              onChanged: (raw) => onDeliveredChanged?.call(line.id, raw),
            ),
            AppSpacing.vertical(context, 0.008),
            _QtyField(
              label: AppTexts.dmRejectedQty,
              value: rejectedText ?? '',
              onChanged: (raw) => onRejectedChanged?.call(line.id, raw),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(double qty) {
    if (qty == qty.roundToDouble()) return qty.round().toString();
    return qty.toStringAsFixed(1);
  }
}

class _QtyField extends StatefulWidget {
  const _QtyField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_QtyField> createState() => _QtyFieldState();
}

class _QtyFieldState extends State<_QtyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _QtyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: widget.onChanged,
      label: widget.label,
      hint: AppTexts.dmDeliveredQtyHint,
      prefixIcon: AppIcons.myshops,
    );
  }
}
