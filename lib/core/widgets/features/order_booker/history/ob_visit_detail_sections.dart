import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/history/ob_visit_detail_line_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_detail_model.dart';

class ObVisitDetailInfoSection extends StatelessWidget {
  const ObVisitDetailInfoSection({
    super.key,
    required this.visit,
    required this.checkInLabel,
    required this.checkOutLabel,
  });

  final ObVisitDetailModel visit;
  final String checkInLabel;
  final String checkOutLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.obVisitInfoSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.01),
        AppOutlineCard(
          statusColor: visit.outcome.chipColor,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppDetailRow(
                label: AppTexts.obVisitOutcomeLabel,
                trailing: AppStatusChip.visitOutcome(visit.outcome),
                showDivider: true,
              ),
              AppDetailRow(
                label: AppTexts.obVisitCheckInAt,
                value: checkInLabel,
              ),
              AppDetailRow(
                label: AppTexts.obVisitCheckOutAt,
                value: checkOutLabel,
              ),
              if (visit.ownerName != null)
                AppDetailRow(
                  label: AppTexts.obOwnerNameLabel,
                  value: visit.ownerName!,
                ),
              if (visit.shopPhone != null)
                AppDetailRow(
                  label: AppTexts.obPhoneNumberLabel,
                  value: visit.shopPhone!,
                ),
              if (visit.locationLabel != null)
                AppDetailRow(
                  label: AppTexts.obLocationLabel,
                  value: visit.locationLabel!,
                  showDivider: visit.orderNumber == null,
                ),
              if (visit.orderNumber != null)
                AppDetailRow(
                  label: AppTexts.obOrderNumberLabel,
                  value: visit.orderNumber!,
                  showDivider: false,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class ObVisitDetailLinesSection extends StatelessWidget {
  const ObVisitDetailLinesSection({super.key, required this.visit});

  final ObVisitDetailModel visit;

  @override
  Widget build(BuildContext context) {
    if (visit.lines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.obVisitLinesSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.01),
        ...visit.lines.map(
          (line) => Padding(
            padding: EdgeInsets.only(
              bottom: AppSpacing.verticalValue(context, 0.01),
            ),
            child: ObVisitDetailLineTile(line: line),
          ),
        ),
        Container(
          padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppTexts.obSubtotal,
                  style: AppTextStyles.caption(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                AppFormatter.currencyWhole(visit.subtotal),
                style: AppTextStyles.bodyText(context).copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ObVisitDetailNotesSection extends StatelessWidget {
  const ObVisitDetailNotesSection({super.key, required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppTexts.obTaskNotes, style: AppTextStyles.sectionTitle(context)),
        AppSpacing.vertical(context, 0.01),
        AppOutlineCard(
          child: Text(notes, style: AppTextStyles.bodyText(context)),
        ),
      ],
    );
  }
}
