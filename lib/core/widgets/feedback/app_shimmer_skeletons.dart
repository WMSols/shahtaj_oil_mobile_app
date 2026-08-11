import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_shimmer.dart';

/// Role-agnostic screen skeletons built from [AppShimmer] factories.
class AppShimmerSkeletons {
  AppShimmerSkeletons._();

  static Widget dashboard(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: AppSpacing.screenPadding(context),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AppShimmer.line(widthFactor: 0.35, height: 12),
          SizedBox(height: AppSpacing.verticalValue(context, 0.008)),
          AppShimmer.line(widthFactor: 0.55, height: 22),
          SizedBox(height: AppSpacing.verticalValue(context, 0.008)),
          AppShimmer.line(widthFactor: 0.7, height: 12),
          SizedBox(height: AppSpacing.verticalValue(context, 0.02)),
          _solidCard(context, height: 72),
          SizedBox(height: AppSpacing.verticalValue(context, 0.02)),
          AppShimmer.line(widthFactor: 0.4, height: 14),
          SizedBox(height: AppSpacing.verticalValue(context, 0.012)),
          AppShimmer.listCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppShimmer.line(widthFactor: 0.6, height: 14),
                    ),
                    AppShimmer.chip(),
                  ],
                ),
                SizedBox(height: AppSpacing.verticalValue(context, 0.012)),
                AppShimmer.line(widthFactor: 0.45, height: 11),
                SizedBox(height: AppSpacing.verticalValue(context, 0.012)),
                AppShimmer.box(height: 8, radius: 8),
                SizedBox(height: AppSpacing.verticalValue(context, 0.012)),
                AppShimmer.box(
                  height: 40,
                  radius: AppResponsive.radius(context),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.verticalValue(context, 0.02)),
          AppShimmer.line(widthFactor: 0.3, height: 14),
          SizedBox(height: AppSpacing.verticalValue(context, 0.012)),
          _solidCard(context, height: 110),
          SizedBox(height: AppSpacing.verticalValue(context, 0.02)),
          AppShimmer.line(widthFactor: 0.4, height: 14),
          SizedBox(height: AppSpacing.verticalValue(context, 0.012)),
          AppShimmer.list(context: context, count: 3),
        ],
      ),
    );
  }

  static Widget taskList(BuildContext context, {int count = 5}) {
    return AppShimmer(
      child: ListView(
        padding: AppSpacing.screenPadding(context),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AppShimmer.listCard(context),
          SizedBox(height: AppSpacing.verticalValue(context, 0.016)),
          AppShimmer.line(widthFactor: 0.5, height: 12),
          SizedBox(height: AppSpacing.verticalValue(context, 0.008)),
          AppShimmer.box(height: 8, radius: 8),
          SizedBox(height: AppSpacing.verticalValue(context, 0.02)),
          AppShimmer.line(widthFactor: 0.35, height: 14),
          SizedBox(height: AppSpacing.verticalValue(context, 0.012)),
          AppShimmer.list(
            context: context,
            count: count,
            itemBuilder: (context, _) => AppShimmer.listCard(
              context,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer.circle(size: 28),
                  SizedBox(width: AppSpacing.horizontalValue(context, 0.02)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppShimmer.line(
                                widthFactor: 0.7,
                                height: 14,
                              ),
                            ),
                            AppShimmer.chip(width: 72),
                          ],
                        ),
                        SizedBox(
                          height: AppSpacing.verticalValue(context, 0.01),
                        ),
                        AppShimmer.line(widthFactor: 0.45, height: 11),
                        SizedBox(
                          height: AppSpacing.verticalValue(context, 0.01),
                        ),
                        AppShimmer.box(
                          height: 32,
                          radius: AppResponsive.radius(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget shopList(BuildContext context, {int count = 5}) {
    return AppShimmer(
      child: Padding(
        padding: AppSpacing.screenPadding(context),
        child: AppShimmer.list(context: context, count: count),
      ),
    );
  }

  static Widget genericList(BuildContext context, {int count = 6}) {
    return AppShimmer(
      child: ListView(
        padding: AppSpacing.screenPadding(context),
        physics: const NeverScrollableScrollPhysics(),
        children: [AppShimmer.list(context: context, count: count)],
      ),
    );
  }

  static Widget detail(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: AppSpacing.screenPadding(context),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AppShimmer.box(
            height: AppSpacing.verticalValue(context, 0.22),
            radius: AppResponsive.radius(context),
          ),
          SizedBox(height: AppSpacing.verticalValue(context, 0.016)),
          AppShimmer.listCard(context),
          SizedBox(height: AppSpacing.verticalValue(context, 0.016)),
          AppShimmer.list(context: context, count: 4),
        ],
      ),
    );
  }

  static Widget _solidCard(BuildContext context, {required double height}) {
    return AppShimmer.box(
      height: height,
      radius: AppResponsive.radius(context),
    );
  }
}
