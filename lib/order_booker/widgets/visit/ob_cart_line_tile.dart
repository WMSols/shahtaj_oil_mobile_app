import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_icon_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/visit/ob_order_create_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';

class ObCartLineTile extends StatefulWidget {
  const ObCartLineTile({
    super.key,
    required this.controller,
    required this.line,
  });

  final ObOrderCreateController controller;
  final ObVisitCartLineModel line;

  @override
  State<ObCartLineTile> createState() => _ObCartLineTileState();
}

class _ObCartLineTileState extends State<ObCartLineTile> {
  late final TextEditingController _qtyController;
  late final TextEditingController _rateController;
  late final FocusNode _qtyFocusNode;
  late final FocusNode _rateFocusNode;

  ObOrderCreateController get _c => widget.controller;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(
      text: _c.quantityFieldText(widget.line),
    );
    _rateController = TextEditingController(
      text: _c.rateFieldText(widget.line),
    );
    _qtyFocusNode = FocusNode()..addListener(_onQtyFocusChange);
    _rateFocusNode = FocusNode()..addListener(_onRateFocusChange);
  }

  @override
  void didUpdateWidget(covariant ObCartLineTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_qtyFocusNode.hasFocus) {
      final nextQty = _c.quantityFieldText(widget.line);
      if (_qtyController.text != nextQty) _qtyController.text = nextQty;
    }
    if (!_rateFocusNode.hasFocus) {
      final nextRate = _c.rateFieldText(widget.line);
      if (_rateController.text != nextRate) _rateController.text = nextRate;
    }
  }

  @override
  void dispose() {
    _qtyFocusNode.removeListener(_onQtyFocusChange);
    _rateFocusNode.removeListener(_onRateFocusChange);
    _qtyFocusNode.dispose();
    _rateFocusNode.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _onQtyFocusChange() {
    if (!_qtyFocusNode.hasFocus) {
      unawaited(_commitQtyAndSyncField());
    }
  }

  Future<void> _commitQtyAndSyncField() async {
    final lineId = widget.line.lineId;
    await _c.commitQuantityInput(lineId);
    if (!mounted || _qtyFocusNode.hasFocus) return;
    final line = _c.lineById(lineId) ?? widget.line;
    final next = _c.quantityFieldText(line);
    if (_qtyController.text != next) {
      _qtyController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
  }

  void _onRateFocusChange() {
    if (!_rateFocusNode.hasFocus) {
      _c.commitRateInput(widget.line.lineId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lineId = widget.line.lineId;

    return Obx(() {
      final line = _c.lineById(lineId) ?? widget.line;
      final maxQuantity = _c.maxQuantityForLine(line);
      final bookableLabel = _c.bookableLabel(line);
      final errorText = _c.quantityError(lineId);
      final rateError = _c.rateError(lineId);
      final displayTotal = _c.displayLineTotal(line);
      final isRemoving = _c.removingLineId.value == lineId;
      final appRate = _c.appRateForLine(line);
      final isDiscounted = _c.proposedRateForLine(line) < appRate - 0.001;

      return AppOutlineCard(
        color: AppColors.grey.withValues(alpha: 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    line.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyText(
                      context,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                AppIconButton(
                  icon: AppIcons.delete,
                  iconColor: AppColors.error,
                  isLoading: isRemoving,
                  onTap: isRemoving ? null : () => _c.removeLine(lineId),
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.006),
            Text(
              AppTexts.obQtyBookable(bookableLabel, line.unit ?? ''),
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.grey),
            ),
            AppSpacing.vertical(context, 0.01),
            _LabeledValue(
              label: AppTexts.obCartAppRateHint,
              child: Text(
                AppFormatter.currencyWhole(appRate),
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            AppSpacing.vertical(context, 0.01),
            AppTextField(
              controller: _rateController,
              focusNode: _rateFocusNode,
              label: AppTexts.obProposedRateLabel,
              hint: AppTexts.obProposedRateHint,
              prefixIcon: AppIcons.orders,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              textInputAction: TextInputAction.next,
              onChanged: (raw) => _c.onRateInputChanged(lineId, raw),
              onSubmitted: (_) => _c.commitRateInput(lineId),
              errorText: rateError,
            ),
            if (isDiscounted) ...[
              AppSpacing.vertical(context, 0.006),
              Text(
                '${AppTexts.obRateVariance}: ${AppFormatter.currencyWhole(appRate - _c.proposedRateForLine(line))}',
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.warning),
              ),
            ],
            AppSpacing.vertical(context, 0.01),
            AppTextField(
              controller: _qtyController,
              focusNode: _qtyFocusNode,
              label: AppTexts.obCartQuantityHint,
              hint: AppTexts.obCartQuantityInputHint(
                '$maxQuantity',
                line.productName,
              ),
              prefixIcon: AppIcons.myshops,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              textInputAction: TextInputAction.done,
              onChanged: (raw) => _c.onQuantityInputChanged(lineId, raw),
              onSubmitted: (_) => unawaited(_commitQtyAndSyncField()),
              errorText: errorText,
              textColor: AppColors.primary,
            ),
            AppSpacing.vertical(context, 0.01),
            _LabeledValue(
              label: AppTexts.obTotalLabel,
              child: Text(
                AppFormatter.currencyWhole(displayTotal),
                style: AppTextStyles.bodyText(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
          ),
        ),
        AppSpacing.horizontal(context, 0.004),
        child,
      ],
    );
  }
}
