import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_filter_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_empty_state.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_search_field.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/shared/dm_order_card.dart';

/// Shared search (+ optional status filters) + order card list for DM screens.
class DmOrderListContent extends StatelessWidget {
  const DmOrderListContent({
    super.key,
    required this.orders,
    required this.onRefresh,
    required this.onQueryChanged,
    required this.onOrderTap,
    this.filterStatuses,
    this.isFilterSelected,
    this.onFilterSelected,
    this.emptyTitle,
    this.emptyWhenNoQueryTitle,
    this.queryIsEmpty = true,
  });

  final List<DmDeliveryOrderModel> orders;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<DmDeliveryOrderModel> onOrderTap;
  final List<DeliveryStatus>? filterStatuses;
  final bool Function(DeliveryStatus?)? isFilterSelected;
  final ValueChanged<DeliveryStatus?>? onFilterSelected;
  final String? emptyTitle;
  final String? emptyWhenNoQueryTitle;
  final bool queryIsEmpty;

  bool get _showFilters =>
      filterStatuses != null &&
      isFilterSelected != null &&
      onFilterSelected != null;

  @override
  Widget build(BuildContext context) {
    final showEmptyNoQuery =
        orders.isEmpty && queryIsEmpty && emptyWhenNoQueryTitle != null;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: showEmptyNoQuery
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: AppSpacing.verticalValue(context, 0.12)),
                AppEmptyState(
                  title: emptyWhenNoQueryTitle!,
                  subtitle: AppTexts.noDataYet,
                ),
              ],
            )
          : ListView(
              padding: AppSpacing.screenPadding(context),
              children: [
                AppSearchField(
                  hint: AppTexts.search,
                  onChanged: onQueryChanged,
                ),
                if (_showFilters) ...[
                  AppSpacing.vertical(context, 0.012),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        AppFilterChip(
                          label: AppTexts.obShopsFilterAll,
                          selected: isFilterSelected!(null),
                          onTap: () => onFilterSelected!(null),
                        ),
                        for (final status in filterStatuses!)
                          AppFilterChip.deliveryStatus(
                            status: status,
                            selected: isFilterSelected!(status),
                            onTap: () => onFilterSelected!(status),
                          ),
                      ],
                    ),
                  ),
                ],
                AppSpacing.vertical(context, 0.014),
                if (orders.isEmpty)
                  AppEmptyState(
                    title: emptyTitle ?? AppTexts.emptyNoOrdersTitle,
                    subtitle: AppTexts.noDataYet,
                  )
                else
                  ...orders.map(
                    (order) => Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSpacing.verticalValue(context, 0.01),
                      ),
                      child: DmOrderCard(
                        order: order,
                        onTap: () => onOrderTap(order),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
