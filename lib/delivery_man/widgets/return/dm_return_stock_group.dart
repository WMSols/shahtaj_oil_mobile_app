import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_section_header.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/return/dm_return_model.dart';

class DmReturnStockGroup extends StatelessWidget {
  const DmReturnStockGroup({
    super.key,
    required this.title,
    required this.lines,
    this.statusColor,
    this.editable = false,
    this.onQtyChanged,
  });

  final String title;
  final List<DmReturnLineModel> lines;
  final Color? statusColor;
  final bool editable;
  final void Function(int index, String raw)? onQtyChanged;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.verticalValue(context, 0.014),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: title, bottomSpacing: true),
          AppOutlineCard(
            statusColor: statusColor,
            padding: AppSpacing.symmetric(context, h: 0.035, v: 0.014),
            child: Column(
              children: [
                for (var i = 0; i < lines.length; i++) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lines[i].productName,
                              style: AppTextStyles.bodyText(context),
                            ),
                            if (lines[i].reason != null &&
                                lines[i].reason!.isNotEmpty)
                              Text(
                                lines[i].reason!,
                                style: AppTextStyles.caption(context),
                              ),
                          ],
                        ),
                      ),
                      if (editable)
                        _EditableQty(
                          key: ValueKey('${title}_${lines[i].productId}_$i'),
                          quantity: lines[i].quantity,
                          onChanged: (raw) => onQtyChanged?.call(i, raw),
                        )
                      else
                        Text(
                          '${lines[i].quantity}',
                          style: AppTextStyles.sectionTitle(context),
                        ),
                    ],
                  ),
                  if (i < lines.length - 1) ...[
                    AppSpacing.vertical(context, 0.008),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    AppSpacing.vertical(context, 0.008),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableQty extends StatefulWidget {
  const _EditableQty({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<String> onChanged;

  @override
  State<_EditableQty> createState() => _EditableQtyState();
}

class _EditableQtyState extends State<_EditableQty> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.quantity}');
  }

  @override
  void didUpdateWidget(covariant _EditableQty oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity &&
        _controller.text != '${widget.quantity}') {
      _controller.text = '${widget.quantity}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.inputFill,
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
