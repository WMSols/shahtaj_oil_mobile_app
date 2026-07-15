import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/common/models/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_profile_avatar.dart';

class AccountProfileHeader extends StatelessWidget {
  const AccountProfileHeader({
    super.key,
    required this.user,
    required this.role,
    required this.presenceStatus,
  });

  final UserModel user;
  final UserRole role;
  final PresenceStatus presenceStatus;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      statusColor: AppColors.primary,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppProfileAvatar(
            size: 72,
            name: user.displayName(AppTexts.defaultUserName),
            presenceStatus: presenceStatus,
            showPresenceDot: true,
          ),
          AppSpacing.horizontal(context, 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName(AppTexts.defaultUserName),
                  style: AppTextStyles.heading(
                    context,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                AppSpacing.vertical(context, 0.008),
                Wrap(
                  spacing: AppSpacing.horizontalValue(context, 0.015),
                  runSpacing: AppSpacing.verticalValue(context, 0.006),
                  children: [
                    AppStatusChip.role(role),
                    AppStatusChip.presence(presenceStatus),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
