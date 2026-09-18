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
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_payment_model.dart';

class DmPaidInvoiceTile extends StatelessWidget {
  const DmPaidInvoiceTile({super.key, required this.invoice});

  final DmRecoveryInvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);
    final paidOn = invoice.paidDate ?? invoice.invoiceDate;

    return AppOutlineCard(
      statusColor: AppColors.success,
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.014),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.name,
                      style: AppTextStyles.sectionTitle(context),
                    ),
                    if (invoice.invoiceDate != null) ...[
                      AppSpacing.vertical(context, 0.004),
                      Text(
                        AppFormatter.shortDate(invoice.invoiceDate!),
                        style: mutedStyle,
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppStatusChip(
                    label: AppTexts.dmPaidInvoiceChip,
                    color: AppColors.success,
                    soft: true,
                  ),
                  AppSpacing.vertical(context, 0.006),
                  Text(
                    AppFormatter.currency(invoice.amountTotal, symbol: 'Rs. '),
                    style: AppTextStyles.sectionTitle(
                      context,
                    ).copyWith(color: AppColors.success),
                  ),
                ],
              ),
            ],
          ),
          if (paidOn != null) ...[
            AppSpacing.vertical(context, 0.008),
            Text(
              '${AppTexts.dmPaidOn}: ${AppFormatter.shortDate(paidOn)}',
              style: mutedStyle.copyWith(
                fontSize: AppResponsive.scaleSize(context, 12),
              ),
            ),
          ],
          if (invoice.payments.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.01),
            for (var i = 0; i < invoice.payments.length; i++) ...[
              if (i > 0) AppSpacing.vertical(context, 0.008),
              _PaymentRow(payment: invoice.payments[i]),
            ],
          ],
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment});

  final DmRecoveryPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(
      context,
    ).copyWith(color: AppColors.grey);

    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(
          AppResponsive.scaleSize(context, 10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  payment.paymentName.isEmpty
                      ? AppTexts.dmPaymentMethod
                      : payment.paymentName,
                  style: AppTextStyles.bodyText(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                AppFormatter.currency(payment.amount, symbol: 'Rs. '),
                style: AppTextStyles.bodyText(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.006),
          Wrap(
            spacing: AppSpacing.horizontalValue(context, 0.015),
            runSpacing: AppSpacing.verticalValue(context, 0.006),
            children: [
              AppStatusChip.paymentMethod(payment.paymentMethod),
              if (payment.isDmWalletCollection)
                AppStatusChip(
                  label: AppTexts.dmWalletCollectionChip,
                  color: AppColors.information,
                  soft: true,
                ),
            ],
          ),
          if (payment.paymentDate != null) ...[
            AppSpacing.vertical(context, 0.006),
            Text(
              AppFormatter.shortDate(payment.paymentDate!),
              style: mutedStyle.copyWith(
                fontSize: AppResponsive.scaleSize(context, 12),
              ),
            ),
          ],
          if (payment.paymentMethod == PaymentMethod.cheque &&
              (payment.chequeNumber ?? '').isNotEmpty) ...[
            AppSpacing.vertical(context, 0.004),
            Text(
              '${AppTexts.dmChequeNumber}: ${payment.chequeNumber}',
              style: mutedStyle.copyWith(
                fontSize: AppResponsive.scaleSize(context, 12),
              ),
            ),
          ],
          if ((payment.collectedByDmName ?? '').isNotEmpty) ...[
            AppSpacing.vertical(context, 0.004),
            Text(
              '${AppTexts.dmCollectedBy}: ${payment.collectedByDmName}',
              style: mutedStyle.copyWith(
                fontSize: AppResponsive.scaleSize(context, 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
