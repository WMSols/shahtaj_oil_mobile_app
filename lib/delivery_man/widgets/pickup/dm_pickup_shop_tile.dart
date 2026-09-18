import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/pickup/dm_pickup_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';

class DmPickupShopTile extends StatelessWidget {
  const DmPickupShopTile({
    super.key,
    required this.job,
    required this.controller,
  });

  final DmJobModel job;
  final DmPickupController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expanded = controller.expandedJobId.value == job.jobId;
      final canPick = job.lines.any((l) {
        final remaining = l.qtyStill > 0
            ? l.qtyStill
            : (l.qtyAssigned - l.qtyPicked);
        return remaining > 0;
      });

      return AppOutlineCard(
        statusColor: job.state.chipColor,
        padding: AppSpacing.symmetric(context, h: 0.02, v: 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => controller.toggleJobExpanded(job.jobId),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.shopName,
                          style: AppTextStyles.sectionTitle(context),
                        ),
                        if ((job.orderName ?? '').isNotEmpty)
                          Text(
                            job.orderName!,
                            style: AppTextStyles.caption(
                              context,
                            ).copyWith(color: AppColors.grey),
                          ),
                      ],
                    ),
                  ),
                  AppStatusChip(
                    label: job.state.label,
                    color: job.state.chipColor,
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),
            if (expanded) ...[
              AppSpacing.vertical(context, 0.01),
              if (job.lines.isEmpty)
                Text(
                  AppTexts.dmJobPickNoLines,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: AppColors.grey),
                )
              else ...[
                for (final line in job.lines) ...[
                  Text(line.name, style: AppTextStyles.bodyText(context)),
                  Text(
                    '${AppTexts.dmQtyStill}: ${AppFormatter.targetAmount(line.qtyStill > 0 ? line.qtyStill : (line.qtyAssigned - line.qtyPicked))}'
                    '${(line.uom ?? '').isNotEmpty ? ' ${line.uom}' : ''}',
                    style: AppTextStyles.caption(
                      context,
                    ).copyWith(color: AppColors.grey),
                  ),
                  AppSpacing.vertical(context, 0.006),
                  AppTextField(
                    controller: controller.jobQtyControllerFor(job.jobId, line),
                    label: AppTexts.dmLoadedQty,
                    hint: AppTexts.dmLoadedQtyHint,
                    prefixIcon: AppIcons.myshops,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    textInputAction: TextInputAction.done,
                    onChanged: (raw) =>
                        controller.onJobQtyChanged(job.jobId, line, raw),
                    errorText:
                        controller.jobQtyErrors['${job.jobId}:${line.lineId}'],
                  ),
                  AppSpacing.vertical(context, 0.01),
                ],
                if (canPick)
                  AppPrimaryButton(
                    label: AppTexts.dmConfirmJobPick,
                    isLoading: controller.submittingJobId.value == job.jobId,
                    onPressed: () => controller.confirmJobPick(job),
                  ),
              ],
            ],
          ],
        ),
      );
    });
  }
}
