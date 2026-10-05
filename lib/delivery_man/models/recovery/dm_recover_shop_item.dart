import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_shop_model.dart';

/// One shop on the Recover list (plan shop + recovery summary).
class DmRecoverShopItem {
  const DmRecoverShopItem({
    required this.shopId,
    required this.shopName,
    this.orderName,
    this.outstanding = 0,
    this.unpaidCount = 0,
    this.paidCount = 0,
    this.creditExceeded = false,
    this.detailsLoaded = false,
  });

  final String shopId;
  final String shopName;
  final String? orderName;
  final double outstanding;
  final int unpaidCount;
  final int paidCount;
  final bool creditExceeded;
  final bool detailsLoaded;

  DmRecoverShopItem copyWith({
    String? shopId,
    String? shopName,
    String? orderName,
    double? outstanding,
    int? unpaidCount,
    int? paidCount,
    bool? creditExceeded,
    bool? detailsLoaded,
  }) {
    return DmRecoverShopItem(
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      orderName: orderName ?? this.orderName,
      outstanding: outstanding ?? this.outstanding,
      unpaidCount: unpaidCount ?? this.unpaidCount,
      paidCount: paidCount ?? this.paidCount,
      creditExceeded: creditExceeded ?? this.creditExceeded,
      detailsLoaded: detailsLoaded ?? this.detailsLoaded,
    );
  }

  factory DmRecoverShopItem.fromRecovery(
    DmRecoveryShopModel shop, {
    String? orderName,
  }) {
    final open = shop.openInvoices;
    final unpaid = open.isNotEmpty ? open.length : shop.invoiceCount;
    final paid = shop.paidInvoiceCount > 0
        ? shop.paidInvoiceCount
        : shop.paidInvoices.length;
    return DmRecoverShopItem(
      shopId: shop.shopId,
      shopName: shop.shopName.isNotEmpty ? shop.shopName : shop.shopId,
      orderName: orderName,
      outstanding: shop.outstanding > 0
          ? shop.outstanding
          : shop.effectiveOutstanding,
      unpaidCount: unpaid,
      paidCount: paid,
      creditExceeded: shop.isCreditLimitExceeded,
      detailsLoaded: true,
    );
  }
}
