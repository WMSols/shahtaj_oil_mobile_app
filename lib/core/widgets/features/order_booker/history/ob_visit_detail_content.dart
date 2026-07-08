import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_secondary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/history/ob_visit_detail_sections.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/visit/ob_visit_header_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_visit_detail_controller.dart';

class ObVisitDetailContent extends GetView<ObVisitDetailController> {
  const ObVisitDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    final visit = controller.visit.value!;

    return RefreshIndicator(
      onRefresh: controller.loadDetail,
      child: ListView(
        padding: AppSpacing.screenPadding(context),
        children: [
          ObVisitHeaderCard(shopName: visit.shopName, visitId: visit.visitId),
          AppSpacing.vertical(context, 0.02),
          ObVisitDetailInfoSection(
            visit: visit,
            checkInLabel: controller.formatDateTime(visit.checkedInAt),
            checkOutLabel: controller.formatDateTime(visit.checkedOutAt),
          ),
          AppSpacing.vertical(context, 0.02),
          ObVisitDetailLinesSection(visit: visit),
          if (controller.hasNotes) ...[
            AppSpacing.vertical(context, 0.02),
            ObVisitDetailNotesSection(notes: controller.notes!),
          ],
          if (visit.hasOrder) ...[
            AppSpacing.vertical(context, 0.02),
            AppPrimaryButton(
              label: AppTexts.obViewOrder,
              onPressed: controller.openOrder,
            ),
          ],
          if (visit.shopPhone != null) ...[
            AppSpacing.vertical(context, 0.01),
            AppSecondaryButton(
              label: AppTexts.obCallOwner,
              outlinedOnly: true,
              onPressed: controller.callOwner,
            ),
          ],
          if (visit.latitude != null && visit.longitude != null) ...[
            AppSpacing.vertical(context, 0.01),
            AppSecondaryButton(
              label: AppTexts.obDirections,
              outlinedOnly: true,
              onPressed: controller.openDirections,
            ),
          ],
          AppSpacing.vertical(context, 0.02),
        ],
      ),
    );
  }
}
