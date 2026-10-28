import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/sync/sync_center_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';

class SyncCenterScreen extends GetView<SyncCenterController> {
  const SyncCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.syncCenterTitle,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return AppEmptyState(
            title: AppTexts.syncEmptyTitle,
            subtitle: AppTexts.syncEmptySubtitle,
            onRefresh: controller.load,
          );
        }

        final groups = controller.groups;
        final otherUser = controller.otherUserPendingCount;
        final extra = otherUser > 0 ? 1 : 0;
        final busy = controller.isRetrying.value;

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.separated(
            padding: AppSpacing.screenPadding(context),
            itemCount: groups.length + extra,
            separatorBuilder: (_, _) => AppSpacing.vertical(context, 0.01),
            itemBuilder: (context, index) {
              if (index < groups.length) {
                return _SyncVisitGroupCard(
                  group: groups[index],
                  controller: controller,
                  retryDisabled: busy,
                );
              }

              return AppOutlineCard(
                child: Text(
                  AppTexts.obSyncOtherUserPending,
                  style: AppTextStyles.bodyText(
                    context,
                  ).copyWith(color: AppColors.grey),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _SyncVisitGroupCard extends StatelessWidget {
  const _SyncVisitGroupCard({
    required this.group,
    required this.controller,
    required this.retryDisabled,
  });

  final SyncQueueGroup group;
  final SyncCenterController controller;
  final bool retryDisabled;

  @override
  Widget build(BuildContext context) {
    final overall = controller.overallStatusFor(group);
    final showRetry = controller.showRetryFor(group);
    final blockedBy = controller.blockedByLabel(group);
    final detailChunks = <String>[
      for (final entry in group.entries)
        if (controller.detailLinesFor(entry).isNotEmpty)
          controller.detailLinesFor(entry),
    ];

    return AppOutlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  group.title,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              AppStatusChip.sync(overall),
            ],
          ),
          AppSpacing.vertical(context, 0.01),
          Wrap(
            spacing: AppSpacing.horizontalValue(context, 0.015),
            runSpacing: AppSpacing.verticalValue(context, 0.008),
            children: [
              for (final entry in group.entries)
                AppStatusChip(
                  label: controller.labelFor(entry),
                  color: controller.statusFor(entry).chipColor,
                  soft: true,
                ),
            ],
          ),
          AppSpacing.vertical(context, 0.01),
          Text(
            controller.groupMetaLine(group),
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.grey),
          ),
          if (blockedBy != null) ...[
            AppSpacing.vertical(context, 0.006),
            Text(
              blockedBy,
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(color: AppColors.grey),
            ),
          ],
          for (final chunk in detailChunks) ...[
            AppSpacing.vertical(context, 0.006),
            Text(
              chunk,
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(color: AppColors.grey),
            ),
          ],
          if (showRetry) ...[
            AppSpacing.vertical(context, 0.012),
            AppPrimaryButton(
              label: controller.retryLabelFor(group),
              isLoading: controller.isRetrying.value,
              onPressed: retryDisabled
                  ? null
                  : () => controller.retryGroup(group),
            ),
          ],
          if (group.hasFailedOrNeedsReview) ...[
            AppSpacing.vertical(context, showRetry ? 0.008 : 0.012),
            AppSecondaryButton(
              label: AppTexts.clearThisItem,
              outlinedOnly: true,
              textColor: AppColors.error,
              borderColor: AppColors.error,
              isLoading: controller.isClearing.value,
              onPressed: retryDisabled
                  ? null
                  : () => controller.clearGroup(group),
            ),
          ],
        ],
      ),
    );
  }
}
