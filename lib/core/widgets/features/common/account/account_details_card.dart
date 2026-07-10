import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/common/models/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/info/app_detail_row.dart';

class AccountDetailsCard extends StatelessWidget {
  const AccountDetailsCard({super.key, required this.user, required this.role});

  final UserModel user;
  final UserRole role;

  String _orNotAvailable(String? value) {
    if (value == null || value.trim().isEmpty) return AppTexts.notAvailable;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AppDetailRow(label: AppTexts.userId, value: _orNotAvailable(user.id)),
          AppDetailRow(
            label: AppTexts.fullName,
            value: user.displayName(AppTexts.notAvailable),
          ),
          AppDetailRow(
            label: AppTexts.email,
            value: _orNotAvailable(user.email),
          ),
          AppDetailRow(
            label: AppTexts.phone,
            value: _orNotAvailable(user.phone),
          ),
          AppDetailRow(
            label: AppTexts.role,
            trailing: AppStatusChip.role(role),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
