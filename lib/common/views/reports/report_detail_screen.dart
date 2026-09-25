import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/reports/report_detail_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/models/reports/report_message_model.dart';
import 'package:shahtaj_oil_mobile_app/common/widgets/reports/report_message_bubble.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/text/app_plain_text.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';

class ReportDetailScreen extends GetView<ReportDetailController> {
  const ReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.reportDetailTitle,
      body: Obx(() {
        if (controller.isLoading.value && controller.report.value == null) {
          return AppShimmerSkeletons.detail(context);
        }

        final report = controller.report.value;
        if (report == null) {
          return AppEmptyState(
            title: AppTexts.emptyNotFoundTitle,
            subtitle: controller.error.value ?? AppTexts.error,
            image: AppImages.emptyNotFound,
            onRefresh: controller.load,
          );
        }

        final thread = controller.threadItems;

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: AppSpacing.screenPadding(context),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      report.name.isEmpty
                          ? AppTexts.reportPendingSync
                          : report.name,
                      style: AppTextStyles.sectionTitle(context),
                    ),
                  ),
                  AppSpacing.horizontal(context, 0.02),
                  AppStatusChip.report(report.state),
                ],
              ),
              AppSpacing.vertical(context, 0.01),
              Text(
                report.subject,
                style: AppTextStyles.heading(
                  context,
                ).copyWith(fontSize: AppResponsive.scaleSize(context, 18)),
              ),
              if (report.tags.isNotEmpty) ...[
                AppSpacing.vertical(context, 0.012),
                Wrap(
                  spacing: AppSpacing.horizontalValue(context, 0.015),
                  runSpacing: AppSpacing.verticalValue(context, 0.006),
                  children: [
                    for (final tag in report.tags)
                      AppStatusChip(label: tag.name, color: AppColors.primary),
                  ],
                ),
              ],
              AppSpacing.vertical(context, 0.022),
              Text(
                AppTexts.reportMessagesTitle,
                style: AppTextStyles.sectionTitle(context),
              ),
              AppSpacing.vertical(context, 0.012),
              if (controller.isLoadingMessages.value)
                AppShimmerSkeletons.reportMessages(context)
              else ...[
                for (final item in thread)
                  switch (item.kind) {
                    ReportThreadKind.status => ReportStatusPill(message: item),
                    ReportThreadKind.user || ReportThreadKind.office =>
                      ReportMessageBubble(message: item),
                  },
              ],
              if ((report.closingRemark ?? '').trim().isNotEmpty) ...[
                AppSpacing.vertical(context, 0.018),
                Text(
                  AppTexts.reportClosingRemarkLabel,
                  style: AppTextStyles.sectionTitle(context),
                ),
                AppSpacing.vertical(context, 0.008),
                AppOutlineCard(
                  child: Text(
                    AppPlainText.fromHtml(report.closingRemark),
                    style: AppTextStyles.bodyText(context),
                  ),
                ),
              ],
              AppSpacing.vertical(context, 0.02),
            ],
          ),
        );
      }),
    );
  }
}
