import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_outline_icon_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_task_model.dart';

class ObTaskCard extends StatelessWidget {
  const ObTaskCard({
    super.key,
    required this.task,
    this.onCheckIn,
    this.onNotes,
    this.onTap,
    this.isCheckingIn = false,
  });

  final ObTaskModel task;
  final VoidCallback? onCheckIn;
  final VoidCallback? onNotes;
  final VoidCallback? onTap;
  final bool isCheckingIn;

  bool get _canCheckIn => task.status == TaskStatus.pending;

  bool get _hasNotes => task.notes != null && task.notes!.trim().isNotEmpty;

  bool get _showNotesButton => !_hasNotes && onNotes != null;

  bool get _showActions => _canCheckIn || _showNotesButton;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.black,
      fontSize: AppResponsive.scaleSize(context, 13),
    );

    return AppOutlineCard(
      onTap: onTap,
      statusColor: task.status.chipColor,
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
                  color: task.status.chipColor.withValues(alpha: 0.2),
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
                        AppStatusChip.shopVisitTag(task.visitTag),
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
                    isLoading: isCheckingIn,
                    onTap: isCheckingIn ? null : onCheckIn,
                  ),
                if (_canCheckIn && _showNotesButton)
                  AppSpacing.horizontal(context, 0.012),
                if (_showNotesButton)
                  AppOutlineIconButton(
                    icon: AppIcons.history5,
                    label: AppTexts.obTaskNotes,
                    onTap: onNotes,
                  ),
              ],
            ),
          ],
          if (_hasNotes) ...[
            AppSpacing.vertical(context, 0.012),
            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context),
              ),
              child: InkWell(
                onTap: onNotes,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context),
                ),
                child: Padding(
                  padding: AppSpacing.symmetric(context, h: 0.025, v: 0.01),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          AppTexts.obTaskNotePreview(task.notes!.trim()),
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onNotes != null) ...[
                        AppSpacing.horizontal(context, 0.015),
                        Icon(
                          AppIcons.edit,
                          color: AppColors.white,
                          size: AppResponsive.iconSize(context, factor: 0.85),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
          AppSpacing.vertical(context, 0.012),
          AppStatusChip.task(task.status, fullWidth: true),
        ],
      ),
    );
  }
}
