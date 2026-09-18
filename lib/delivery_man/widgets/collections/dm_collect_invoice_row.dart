import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_invoice_model.dart';

class DmCollectInvoiceRow extends StatelessWidget {
  const DmCollectInvoiceRow({
    super.key,
    required this.invoice,
    this.amountController,
    this.onAmountChanged,
    this.onFillRemaining,
  });

  final DmRecoveryInvoiceModel invoice;
  final TextEditingController? amountController;
  final VoidCallback? onAmountChanged;
  final VoidCallback? onFillRemaining;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);
    final editable = amountController != null;

    return AppOutlineCard(
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.014),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  invoice.name,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              if (invoice.invoiceDate != null)
                Text(
                  AppFormatter.shortDate(invoice.invoiceDate!),
                  style: muted.copyWith(
                    fontSize: AppResponsive.scaleSize(context, 12),
                  ),
                ),
            ],
          ),
          AppSpacing.vertical(context, 0.006),
          Text(
            '${AppTexts.dmInvoiceRemaining}: '
            '${AppFormatter.currencyWhole(invoice.amountResidual)}',
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
          if (editable) ...[
            AppSpacing.vertical(context, 0.01),
            AppTextField(
              controller: amountController,
              label: AppTexts.dmCollectAmount,
              hint: AppFormatter.currencyWhole(invoice.amountResidual),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (_) => onAmountChanged?.call(),
              suffixWidget: TextButton(
                onPressed: onFillRemaining,
                child: Text(
                  AppTexts.dmFillRemaining,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
