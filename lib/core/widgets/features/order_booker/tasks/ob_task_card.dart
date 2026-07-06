import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_outline_icon_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';

class ObTaskCard extends StatelessWidget {
  const ObTaskCard({
    super.key,
    required this.task,
    this.onCheckIn,
    this.onSkip,
    this.onNotes,
    this.onTap,
  });

  final ObTaskModel task;
  final VoidCallback? onCheckIn;
  final VoidCallback? onSkip;
  final VoidCallback? onNotes;
  final VoidCallback? onTap;

  bool get _canCheckIn => task.status == TaskStatus.pending;
  bool get _canSkip => task.status == TaskStatus.pending;
  bool get _showActions =>
      _canCheckIn || _canSkip || onNotes != null || onTap != null;

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    final stripeWidth = AppSpacing.horizontalValue(context, 0.012);
    final mutedStyle = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.black,
      fontSize: AppResponsive.scaleSize(context, 13),
    );

    final content = Padding(
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppResponsive.scaleSize(context, 28),
                height: AppResponsive.scaleSize(context, 28),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: task.status.chipColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${task.sequence}',
                  style: AppTextStyles.caption(context).copyWith(
                    color: task.status.chipColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AppSpacing.horizontal(context, 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.shopName,
                            style: AppTextStyles.sectionTitle(context),
                          ),
                        ),
                        AppStatusChip.task(task.status),
                      ],
                    ),
                    if (task.ownerName != null) ...[
                      AppSpacing.vertical(context, 0.005),
                      Text(
                        AppTexts.obShopOwner(task.ownerName!),
                        style: mutedStyle,
                      ),
                    ],
                    if (task.locationLabel != null) ...[
                      AppSpacing.vertical(context, 0.005),
                      Row(
                        children: [
                          Icon(
                            AppIcons.location5,
                            size: AppResponsive.iconSize(context, factor: 0.8),
                            color: AppColors.primary,
                          ),
                          AppSpacing.horizontal(context, 0.01),
                          Expanded(
                            child: Text(
                              task.locationLabel!,
                              style: mutedStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (task.notes != null &&
                        task.notes!.trim().isNotEmpty) ...[
                      AppSpacing.vertical(context, 0.008),
                      Text(
                        task.notes!,
                        style: AppTextStyles.caption(
                          context,
                        ).copyWith(color: AppColors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (_showActions) ...[
            AppSpacing.vertical(context, 0.012),
            Row(
              children: [
                if (_canCheckIn)
                  AppOutlineIconButton(
                    icon: AppIcons.task,
                    label: AppTexts.obTaskCheckIn,
                    onTap: onCheckIn,
                  ),
                if (_canCheckIn && _canSkip)
                  AppSpacing.horizontal(context, 0.012),
                if (_canSkip)
                  AppOutlineIconButton(
                    icon: AppIcons.block5,
                    label: AppTexts.obTaskSkip,
                    onTap: onSkip,
                    foregroundColor: AppColors.warning,
                  ),
                if ((_canCheckIn || _canSkip) && onNotes != null)
                  AppSpacing.horizontal(context, 0.012),
                if (onNotes != null)
                  AppOutlineIconButton(
                    icon: AppIcons.history5,
                    label: AppTexts.obTaskNotes,
                    onTap: onNotes,
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: stripeWidth,
                  color: task.status.chipColor,
                ),
              ),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
