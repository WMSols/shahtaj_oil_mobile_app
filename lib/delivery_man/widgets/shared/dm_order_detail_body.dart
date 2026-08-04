import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_photo_upload_tile.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_text_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_delivery_timeline.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_order_lines_section.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_order_summary_card.dart';

/// Shared order/delivery detail body used by editable and read-only screens.
class DmOrderDetailBody extends StatelessWidget {
  const DmOrderDetailBody({
    super.key,
    required this.order,
    this.editable = false,
    this.canStartDelivery = false,
    this.isActing = false,
    this.deliveredDrafts,
    this.rejectedDrafts,
    this.onDeliveredChanged,
    this.onRejectedChanged,
    this.receiverController,
    this.notesController,
    this.proofPhotoBytes,
    this.onPickProofPhoto,
    this.onStartDelivery,
    this.onConfirmDelivery,
    this.showReadonlyProof = false,
  });

  final DmDeliveryOrderModel order;
  final bool editable;
  final bool canStartDelivery;
  final bool isActing;
  final Map<String, String>? deliveredDrafts;
  final Map<String, String>? rejectedDrafts;
  final void Function(String lineId, String raw)? onDeliveredChanged;
  final void Function(String lineId, String raw)? onRejectedChanged;
  final TextEditingController? receiverController;
  final TextEditingController? notesController;
  final Uint8List? proofPhotoBytes;
  final VoidCallback? onPickProofPhoto;
  final VoidCallback? onStartDelivery;
  final VoidCallback? onConfirmDelivery;
  final bool showReadonlyProof;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.screenPadding(context),
      children: [
        DmOrderSummaryCard(order: order),
        AppSpacing.vertical(context, 0.016),
        DmOrderLinesSection(
          lines: order.lines,
          editable: editable,
          deliveredDrafts: deliveredDrafts,
          rejectedDrafts: rejectedDrafts,
          onDeliveredChanged: onDeliveredChanged,
          onRejectedChanged: onRejectedChanged,
        ),
        if (editable) ...[
          AppSpacing.vertical(context, 0.016),
          AppTextField(
            controller: receiverController!,
            label: AppTexts.dmReceiverNameLabel,
            hint: AppTexts.dmReceiverNameHint,
            prefixIcon: AppIcons.person,
            borderless: true,
            required: true,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.vertical(context, 0.012),
          AppTextField(
            controller: notesController!,
            label: AppTexts.dmNotesHint,
            hint: AppTexts.dmDeliveryNotesHint,
            borderless: true,
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
          ),
          AppSpacing.vertical(context, 0.012),
          SizedBox(
            width: 160,
            child: AppPhotoUploadTile(
              title: AppTexts.dmProofPhotoTitle,
              subtitle: AppTexts.dmProofPhotoSubtitle,
              icon: AppIcons.cameraAdd,
              imageBytes: proofPhotoBytes,
              onTap: onPickProofPhoto,
            ),
          ),
        ],
        if (showReadonlyProof && proofPhotoBytes != null) ...[
          AppSpacing.vertical(context, 0.016),
          SizedBox(
            width: 160,
            child: AppPhotoUploadTile(
              title: AppTexts.dmProofPhotoTitle,
              subtitle: AppTexts.dmProofPhotoSubtitle,
              icon: AppIcons.cameraAdd,
              imageBytes: proofPhotoBytes,
            ),
          ),
        ],
        AppSpacing.vertical(context, 0.016),
        DmDeliveryTimeline(events: order.timeline),
        AppSpacing.vertical(context, 0.02),
        if (canStartDelivery)
          AppPrimaryButton(
            label: AppTexts.dmStartDelivery,
            isLoading: isActing,
            onPressed: onStartDelivery,
          ),
        if (editable)
          AppPrimaryButton(
            label: AppTexts.dmConfirmDelivery,
            isLoading: isActing,
            onPressed: onConfirmDelivery,
          ),
      ],
    );
  }
}
