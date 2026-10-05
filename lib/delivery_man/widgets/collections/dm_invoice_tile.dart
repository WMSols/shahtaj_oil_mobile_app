import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_invoice_model.dart';

class DmInvoiceTile extends StatelessWidget {
  const DmInvoiceTile({
    super.key,
    required this.invoice,
    required this.selected,
    required this.onTap,
  });

  final DmRecoveryInvoiceModel invoice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);
    final paymentState = invoice.resolvedPaymentState;
    final stripeColor = selected
        ? AppColors.primary
        : (paymentState?.chipColor ??
              (invoice.amountResidual > 0 &&
                      invoice.amountResidual < invoice.amountTotal
                  ? AppColors.information
                  : AppColors.warning));

    return AppOutlineCard(
      onTap: onTap,
      statusColor: stripeColor,
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.014),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: AppSpacing.verticalValue(context, 0.002),
            ),
            child: Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.cardBorder,
              size: AppResponsive.scaleSize(context, 22),
            ),
          ),
          AppSpacing.horizontal(context, 0.025),
          Expanded(
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
                    if (paymentState != null)
                      AppStatusChip.invoicePayment(paymentState),
                  ],
                ),
                if (invoice.invoiceDate != null) ...[
                  AppSpacing.vertical(context, 0.004),
                  Text(
                    AppFormatter.shortDate(invoice.invoiceDate!),
                    style: mutedStyle,
                  ),
                ],
                AppSpacing.vertical(context, 0.006),
                Text(
                  '${AppTexts.dmInvoiceTotal}: '
                  '${AppFormatter.currency(invoice.amountTotal, symbol: 'Rs. ')}'
                  ' · ${AppTexts.dmInvoicePaid}: '
                  '${AppFormatter.currency(invoice.amountPaid, symbol: 'Rs. ')}',
                  style: mutedStyle.copyWith(
                    fontSize: AppResponsive.scaleSize(context, 12),
                  ),
                ),
                if (invoice.isLegacyBalance) ...[
                  AppSpacing.vertical(context, 0.006),
                  AppStatusChip(
                    label: AppTexts.dmLegacyBalanceChip,
                    color: AppColors.statPurple,
                    soft: true,
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.horizontal(context, 0.015),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppTexts.dmInvoiceRemaining,
                style: mutedStyle.copyWith(
                  fontSize: AppResponsive.scaleSize(context, 11),
                ),
              ),
              AppSpacing.vertical(context, 0.004),
              Text(
                AppFormatter.currency(invoice.amountResidual, symbol: 'Rs. '),
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
