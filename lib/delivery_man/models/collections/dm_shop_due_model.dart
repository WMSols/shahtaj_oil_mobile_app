import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';

class DmShopDueModel {
  const DmShopDueModel({
    required this.id,
    required this.name,
    this.ownerName = '',
    this.phone = '',
    this.address = '',
    this.outstanding = 0,
    this.invoiceCount = 0,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String name;
  final String ownerName;
  final String phone;
  final String address;
  final double outstanding;
  final int invoiceCount;
  final double? latitude;
  final double? longitude;

  bool get hasHighDue => outstanding >= 50000;
  bool get isPartial => outstanding > 0 && invoiceCount > 0;

  factory DmShopDueModel.fromJson(Map<String, dynamic> json) {
    return DmShopDueModel(
      id: ApiMap.asString(json['id']) ?? '',
      name: ApiMap.asString(json['name']) ?? '',
      ownerName: ApiMap.asString(json['owner_name']) ?? '',
      phone: ApiMap.asString(json['phone']) ?? '',
      address: ApiMap.asString(json['address']) ?? '',
      outstanding: ApiMap.asDouble(json['outstanding']) ?? 0,
      invoiceCount: ApiMap.asInt(json['invoice_count']) ?? 0,
      latitude: ApiMap.asDouble(json['latitude']),
      longitude: ApiMap.asDouble(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner_name': ownerName,
      'phone': phone,
      'address': address,
      'outstanding': outstanding,
      'invoice_count': invoiceCount,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  DmShopDueModel copyWith({double? outstanding, int? invoiceCount}) {
    return DmShopDueModel(
      id: id,
      name: name,
      ownerName: ownerName,
      phone: phone,
      address: address,
      outstanding: outstanding ?? this.outstanding,
      invoiceCount: invoiceCount ?? this.invoiceCount,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
