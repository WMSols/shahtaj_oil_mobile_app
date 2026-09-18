import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer_skeletons.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/wallet/dm_wallet_controller.dart';

class DmWalletScreen extends GetView<DmWalletController> {
  const DmWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (controller.isLoading.value && !controller.hasCachedData) {
          return AppShimmerSkeletons.dashboard(context);
        }
        if (controller.error.value != null && controller.wallet.value == null) {
          return AppEmptyState(
            title: AppTexts.emptyLoadFailedTitle,
            subtitle: controller.error.value!,
            image: AppImages.emptyError,
            onRefresh: () => controller.load(force: true),
          );
        }

        final wallet = controller.wallet.value;
        if (wallet == null) {
          return AppEmptyState(
            title: AppTexts.dmWalletTitle,
            subtitle: AppTexts.dmWalletEmptySubtitle,
            image: AppImages.empty,
            onRefresh: () => controller.load(force: true),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.load(force: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.screenPadding(context),
            children: [
              Text(
                AppTexts.dmWalletTitle,
                style: AppTextStyles.sectionTitle(context),
              ),
              AppSpacing.vertical(context, 0.012),
              AppOutlineCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    AppDetailRow(
                      label: AppTexts.dmWalletBalance,
                      value: AppFormatter.currency(
                        wallet.balance,
                        symbol: 'Rs. ',
                      ),
                    ),
                    AppDetailRow(
                      label: AppTexts.dmSnapshotCollected,
                      value: AppFormatter.currency(
                        wallet.collectedToday,
                        symbol: 'Rs. ',
                      ),
                    ),
                    AppDetailRow(
                      label: AppTexts.dmWalletCollectedTotal,
                      value: AppFormatter.currency(
                        wallet.collectedTotal,
                        symbol: 'Rs. ',
                      ),
                    ),
                    AppDetailRow(
                      label: AppTexts.dmWalletSettledTotal,
                      value: AppFormatter.currency(
                        wallet.settledTotal,
                        symbol: 'Rs. ',
                      ),
                      showDivider: wallet.asOf != null,
                    ),
                    if (wallet.asOf != null)
                      AppDetailRow(
                        label: AppTexts.dmWalletAsOf,
                        value: AppFormatter.shortDate(wallet.asOf!),
                        showDivider: false,
                      ),
                  ],
                ),
              ),
              AppSpacing.vertical(context, 0.02),
              AppPrimaryButton(
                label: AppTexts.dmRecoverShopsTitle,
                onPressed: controller.goToRecoverShops,
              ),
              AppSpacing.vertical(context, 0.01),
              AppSecondaryButton(
                label: AppTexts.dmCollectionHistoryTitle,
                onPressed: controller.goToHistory,
              ),
              if (wallet.balance > 0) ...[
                AppSpacing.vertical(context, 0.016),
                Text(
                  AppTexts.dmWalletHandoverNote,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: AppColors.grey),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
