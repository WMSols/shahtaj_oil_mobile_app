import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/orders/dm_orders_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/orders/dm_job_card.dart';

class DmOrdersContent extends GetView<DmOrdersController> {
  const DmOrdersContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final jobs = controller.visibleJobs;
      final session = controller.sessionState;

      return RefreshIndicator(
        onRefresh: () => controller.loadPlan(force: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          children: [
            if (session != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppTexts.dmTodayPlanTitle,
                      style: AppTextStyles.sectionTitle(context),
                    ),
                  ),
                  AppStatusChip(label: session.label, color: session.chipColor),
                ],
              ),
              AppSpacing.vertical(context, 0.012),
              if (controller.canDepart)
                AppPrimaryButton(
                  label: AppTexts.dmDepartTitle,
                  isLoading: controller.isActing.value,
                  onPressed: controller.depart,
                ),
              if (controller.canEndDay)
                AppSecondaryButton(
                  label: AppTexts.dmEndDayTitle,
                  isLoading: controller.isActing.value,
                  onPressed: controller.endDay,
                ),
              if (controller.canDepart || controller.canEndDay)
                AppSpacing.vertical(context, 0.016),
            ],
            AppSecondaryButton(
              label: AppTexts.dmFreeDeliverTitle,
              onPressed: controller.openFreeDeliver,
            ),
            AppSpacing.vertical(context, 0.016),
            AppSearchField(
              hint: AppTexts.dmSearchJobsHint,
              onChanged: controller.onQueryChanged,
            ),
            AppSpacing.vertical(context, 0.012),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AppFilterChip(
                    label: AppTexts.dmFilterAll,
                    selected: controller.isFilterSelected(null),
                    onTap: () => controller.selectFilter(null),
                    uppercase: false,
                  ),
                  ...controller.filterStates.map(
                    (state) => Padding(
                      padding: EdgeInsets.only(
                        left: AppSpacing.horizontalValue(context, 0.015),
                      ),
                      child: AppFilterChip(
                        label: state.label,
                        selected: controller.isFilterSelected(state),
                        color: state.chipColor,
                        onTap: () => controller.selectFilter(state),
                        uppercase: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.vertical(context, 0.016),
            if (jobs.isEmpty)
              Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.verticalValue(context, 0.06),
                ),
                child: AppEmptyState(title: AppTexts.dmNoJobsToday),
              )
            else
              ...jobs.map(
                (job) => Padding(
                  padding: EdgeInsets.only(
                    bottom: AppSpacing.verticalValue(context, 0.012),
                  ),
                  child: DmJobCard(
                    job: job,
                    onTap: () => controller.openJob(job),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
