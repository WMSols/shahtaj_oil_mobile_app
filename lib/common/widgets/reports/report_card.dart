import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/common/models/reports/report_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report, this.onTap});

  final ReportSummaryModel report;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.grey,
      fontSize: AppResponsive.scaleSize(context, 13),
    );

    return AppOutlineCard(
      onTap: onTap,
      statusColor: report.state.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  report.name.isEmpty
                      ? AppTexts.reportPendingSync
                      : report.name,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              AppStatusChip.report(report.state),
            ],
          ),
          AppSpacing.vertical(context, 0.006),
          Text(report.subject, style: AppTextStyles.bodyText(context)),
          if (report.tags.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.008),
            Wrap(
              spacing: AppSpacing.horizontalValue(context, 0.015),
              runSpacing: AppSpacing.verticalValue(context, 0.006),
              children: [
                for (final tag in report.tags.take(3))
                  AppStatusChip(label: tag.name, color: AppColors.primary),
              ],
            ),
          ],
          AppSpacing.vertical(context, 0.008),
          Row(
            children: [
              if (report.createDate != null)
                Text(
                  AppFormatter.dateTime(report.createDate!.toLocal()),
                  style: muted,
                ),
              const Spacer(),
              if (report.hasScreenshot)
                Icon(
                  Icons.image_outlined,
                  size: AppResponsive.iconSize(context, factor: 0.9),
                  color: AppColors.grey,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
