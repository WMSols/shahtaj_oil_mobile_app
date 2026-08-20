import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_invoice_model.dart';

class RmInvoiceTile extends StatelessWidget {
  const RmInvoiceTile({
    super.key,
    required this.invoice,
    required this.selected,
    required this.onTap,
  });

  final RmInvoiceModel invoice;
  final bool selected;
  final VoidCallback onTap;

  bool get _isPartial =>
      invoice.remainingAmount > 0 &&
      invoice.remainingAmount < invoice.originalAmount;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);

    return AppOutlineCard(
      onTap: onTap,
      statusColor: selected
          ? AppColors.primary
          : (_isPartial ? AppColors.information : AppColors.warning),
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.014),
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: selected ? AppColors.primary : AppColors.cardBorder,
            size: AppResponsive.scaleSize(context, 22),
          ),
          AppSpacing.horizontal(context, 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: AppTextStyles.sectionTitle(context),
                ),
                AppSpacing.vertical(context, 0.004),
                Text(
                  AppFormatter.shortDate(invoice.issuedAt),
                  style: mutedStyle,
                ),
                AppSpacing.vertical(context, 0.006),
                Text(
                  '${AppTexts.rmInvoiceOriginal}: '
                  '${AppFormatter.currency(invoice.originalAmount, symbol: 'Rs. ')}',
                  style: mutedStyle.copyWith(
                    fontSize: AppResponsive.scaleSize(context, 12),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppTexts.rmInvoiceRemaining,
                style: mutedStyle.copyWith(
                  fontSize: AppResponsive.scaleSize(context, 11),
                ),
              ),
              AppSpacing.vertical(context, 0.004),
              Text(
                AppFormatter.currency(invoice.remainingAmount, symbol: 'Rs. '),
                style: AppTextStyles.sectionTitle(
                  context,
                ).copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
