import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_timeline_event_model.dart';

class DmDeliveryTimeline extends StatelessWidget {
  const DmDeliveryTimeline({super.key, required this.events});

  final List<DmTimelineEventModel> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.dmTimelineSection,
          style: AppTextStyles.sectionTitle(context),
        ),
        AppSpacing.vertical(context, 0.008),
        AppOutlineCard(
          padding: AppSpacing.symmetric(context, h: 0.03, v: 0.012),
          child: Column(
            children: [
              for (var i = 0; i < events.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (i < events.length - 1)
                          Container(
                            width: 2,
                            height: 36,
                            color: AppColors.cardBorder,
                          ),
                      ],
                    ),
                    AppSpacing.horizontal(context, 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            events[i].title,
                            style: AppTextStyles.bodyText(
                              context,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            AppFormatter.dateTime(events[i].at),
                            style: AppTextStyles.caption(context),
                          ),
                          if (events[i].note != null &&
                              events[i].note!.isNotEmpty)
                            Text(
                              events[i].note!,
                              style: AppTextStyles.caption(
                                context,
                              ).copyWith(color: AppColors.textPrimary),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
