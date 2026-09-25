import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/common/models/reports/report_message_model.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';

/// Chat bubble: user right / office left. Both use primary fill + white text.
/// Avatars on outer corners. Timestamp under every bubble. No ticks / images.
class ReportMessageBubble extends StatelessWidget {
  const ReportMessageBubble({super.key, required this.message});

  final ReportMessageModel message;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final radius = AppResponsive.radius(context) * 1.6;
    final body = (message.body ?? '').trim();
    if (body.isEmpty) return const SizedBox.shrink();

    final author = (message.authorName ?? '').trim();
    final authorLabel = author.isEmpty
        ? (mine ? AppTexts.reportYouAuthor : AppTexts.reportOfficeAuthor)
        : author;
    final initial = authorLabel.substring(0, 1).toUpperCase();
    final avatarSize = AppResponsive.scaleSize(context, 32);
    final gap = AppSpacing.horizontalValue(context, 0.02);
    final maxBubble =
        MediaQuery.sizeOf(context).width - (avatarSize + gap + 48);

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxBubble * 0.92),
      child: Container(
        padding: AppSpacing.symmetric(context, h: 0.02, v: 0.008),
        decoration: BoxDecoration(
          color: mine ? AppColors.primary : AppColors.success,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(mine ? radius : radius * 0.25),
            bottomRight: Radius.circular(mine ? radius * 0.25 : radius),
          ),
        ),
        child: Text(
          body,
          style: AppTextStyles.bodyText(
            context,
          ).copyWith(color: AppColors.white, height: 1.35),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.verticalValue(context, 0.014),
      ),
      child: Column(
        crossAxisAlignment: mine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: mine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!mine) ...[
                _Avatar(initial: initial, size: avatarSize, mine: mine),
                SizedBox(width: gap),
              ],
              Flexible(child: bubble),
              if (mine) ...[
                SizedBox(width: gap),
                _Avatar(initial: initial, size: avatarSize, mine: mine),
              ],
            ],
          ),
          if (message.createdAt != null) ...[
            AppSpacing.vertical(context, 0.004),
            Padding(
              padding: EdgeInsets.only(
                left: mine ? 0 : avatarSize + gap,
                right: mine ? avatarSize + gap : 0,
              ),
              child: Text(
                AppFormatter.dateTime(message.createdAt!),
                style: AppTextStyles.hintText(
                  context,
                ).copyWith(fontSize: AppResponsive.scaleSize(context, 8)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Centered status: —— pill —— with timestamp under.
class ReportStatusPill extends StatelessWidget {
  const ReportStatusPill({super.key, required this.message});

  final ReportMessageModel message;

  @override
  Widget build(BuildContext context) {
    final body = (message.body ?? '').trim();
    if (body.isEmpty) return const SizedBox.shrink();

    final lineColor = AppColors.grey.withValues(alpha: 0.35);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.verticalValue(context, 0.01),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 1, color: lineColor)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalValue(context, 0.025),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalValue(context, 0.02),
                    vertical: AppSpacing.verticalValue(context, 0.008),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: _StatusLabel(text: body),
                ),
              ),
              Expanded(child: Container(height: 1, color: lineColor)),
            ],
          ),
          if (message.createdAt != null) ...[
            AppSpacing.vertical(context, 0.004),
            Text(
              AppFormatter.dateTime(message.createdAt!),
              style: AppTextStyles.hintText(
                context,
              ).copyWith(fontSize: AppResponsive.scaleSize(context, 8)),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.caption(context).copyWith(
      color: AppColors.black,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
    final accent = base.copyWith(color: AppColors.primary);

    final match = RegExp(
      r'^(.*?)\s*(→|->|—>)\s*(.+?)(?:\s*\(([^)]*)\))?\s*$',
    ).firstMatch(text);

    if (match == null) {
      return Text(text, style: base, textAlign: TextAlign.center);
    }

    final from = match.group(1)?.trim() ?? '';
    final arrow = match.group(2) ?? '→';
    final to = match.group(3)?.trim() ?? '';
    final suffix = match.group(4);

    return Text.rich(
      TextSpan(
        children: [
          if (from.isNotEmpty) TextSpan(text: from, style: base),
          TextSpan(text: ' $arrow ', style: base),
          TextSpan(text: to, style: accent),
          if (suffix != null && suffix.trim().isNotEmpty)
            TextSpan(text: ' ($suffix)', style: base),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.initial,
    required this.size,
    required this.mine,
  });

  final String initial;
  final double size;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: mine ? AppColors.primary : AppColors.success,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.caption(
          context,
        ).copyWith(color: AppColors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}
