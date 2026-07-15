import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_input_decoration.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_order_create_controller.dart';
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
  late final FocusNode _focusNode;

  ObOrderCreateController get _c => widget.controller;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(
      text: _c.quantityFieldText(widget.line),
    );
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant ObCartLineTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusNode.hasFocus) return;

    final next = _c.quantityFieldText(widget.line);
    if (_qtyController.text != next) {
      _qtyController.text = next;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _c.commitQuantityInput(widget.line.lineId);
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
      final displayTotal = _c.displayLineTotal(line);

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
                IconButton(
                  onPressed: () => _c.removeLine(lineId),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: Icon(
                    AppIcons.delete,
                    color: AppColors.error,
                    size: AppResponsive.iconSize(context),
                  ),
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
              label: AppTexts.obCartPriceHint,
              child: Text(
                AppFormatter.currencyWhole(line.priceUnit),
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            AppSpacing.vertical(context, 0.01),
            Text(
              '${AppTexts.obCartQuantityHint} (max $maxQuantity)',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
            ),
            AppSpacing.vertical(context, 0.008),
            TextField(
              controller: _qtyController,
              focusNode: _focusNode,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              textInputAction: TextInputAction.done,
              onChanged: (raw) => _c.onQuantityInputChanged(lineId, raw),
              onSubmitted: (_) => _c.commitQuantityInput(lineId),
              decoration: AppInputDecoration.decoration(
                context,
                hintText: '1',
                borderless: true,
              ).copyWith(errorText: errorText, errorMaxLines: 3),
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
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
