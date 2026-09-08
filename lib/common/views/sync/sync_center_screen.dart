import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/sync/sync_center_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
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

        return Column(
          children: [
            Padding(
              padding: AppSpacing.screenPadding(context),
              child: AppPrimaryButton(
                label: AppTexts.syncNow,
                isLoading: controller.isSyncing.value,
                onPressed: controller.isSyncing.value
                    ? null
                    : controller.syncAll,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.load,
                child: ListView.separated(
                  padding: AppSpacing.screenPadding(context),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, _) =>
                      AppSpacing.vertical(context, 0.01),
                  itemBuilder: (context, index) {
                    final entry = controller.items[index];
                    final status = controller.statusFor(entry);
                    return AppOutlineCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(controller.labelFor(entry)),
                        subtitle: entry.lastError != null
                            ? Text(entry.lastError!)
                            : null,
                        trailing: AppStatusChip.sync(status),
                        onTap:
                            status == SyncStatus.failed ||
                                status == SyncStatus.needsReview
                            ? () => controller.retry(entry.id)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
