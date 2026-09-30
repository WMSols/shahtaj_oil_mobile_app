import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_snapshot_model.dart';

class DmWalkInDeliverResult {
  const DmWalkInDeliverResult({
    this.amountTotal = 0,
    this.invoiceName,
    this.invoiceId,
    this.saleOrderName,
    this.partnerId,
    this.partnerName,
    this.deliveryId,
    this.paymentId,
    this.wallet,
    this.van,
  });

  final double amountTotal;
  final String? invoiceName;
  final int? invoiceId;
  final String? saleOrderName;
  final int? partnerId;
  final String? partnerName;
  final int? deliveryId;
  final int? paymentId;
  final DmWalletModel? wallet;
  final DmVanSnapshotModel? van;

  factory DmWalkInDeliverResult.fromJson(Map<String, dynamic> json) {
    final vanJson = ApiMap.asMap(json['van']);
    final walletJson = ApiMap.asMap(json['wallet']);
    final paymentIds = json['payment_ids'];
    int? paymentId = ApiMap.asInt(json['payment_id']);
    if ((paymentId == null || paymentId <= 0) && paymentIds is List) {
      for (final item in paymentIds) {
        final id = ApiMap.asInt(item);
        if (id != null && id > 0) {
          paymentId = id;
          break;
        }
      }
    }
    return DmWalkInDeliverResult(
      amountTotal: ApiMap.asDouble(json['amount_total']) ?? 0,
      invoiceName: ApiMap.asString(json['invoice_name']),
      invoiceId: ApiMap.asInt(json['invoice_id']),
      saleOrderName: ApiMap.asString(json['sale_order_name']),
      partnerId: ApiMap.asInt(json['partner_id']),
      partnerName: ApiMap.asString(json['partner_name']),
      deliveryId: ApiMap.asInt(json['dm_delivery_id'] ?? json['job_id']),
      paymentId: paymentId,
      wallet: walletJson == null ? null : DmWalletModel.fromJson(walletJson),
      van: vanJson == null ? null : DmVanSnapshotModel.fromJson(vanJson),
    );
  }
}
