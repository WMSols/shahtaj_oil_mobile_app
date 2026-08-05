class ObShopVerifyOnSiteRequest {
  const ObShopVerifyOnSiteRequest({
    required this.shopId,
    required this.taskId,
    required this.latitude,
    required this.longitude,
    required this.shopExteriorPhoto,
    this.ownerCnicNumber,
    this.ownerPhoto,
    this.ownerCnicFront,
    this.ownerCnicBack,
    this.ownerName,
    this.ownerPhone,
    this.shopCategory,
    this.creditLimit,
    this.legacyBalance,
  });

  final int shopId;
  final int taskId;
  final double latitude;
  final double longitude;
  final String shopExteriorPhoto;
  final String? ownerCnicNumber;
  final String? ownerPhoto;
  final String? ownerCnicFront;
  final String? ownerCnicBack;
  final String? ownerName;
  final String? ownerPhone;
  final String? shopCategory;
  final double? creditLimit;
  final double? legacyBalance;

  Map<String, dynamic> toJson() => {
    'shop_id': shopId,
    'task_id': taskId,
    'latitude': latitude,
    'longitude': longitude,
    'shop_exterior_photo': shopExteriorPhoto,
    if (ownerCnicNumber != null && ownerCnicNumber!.trim().isNotEmpty)
      'owner_cnic_number': ownerCnicNumber!.trim(),
    if (ownerPhoto != null) 'owner_photo': ownerPhoto,
    if (ownerCnicFront != null) 'owner_cnic_front': ownerCnicFront,
    if (ownerCnicBack != null) 'owner_cnic_back': ownerCnicBack,
    if (ownerName != null && ownerName!.trim().isNotEmpty)
      'owner_name': ownerName!.trim(),
    if (ownerPhone != null && ownerPhone!.trim().isNotEmpty)
      'owner_phone': ownerPhone!.trim(),
    if (shopCategory != null && shopCategory!.trim().isNotEmpty)
      'shop_category': shopCategory!.trim(),
    if (creditLimit != null) 'credit_limit': creditLimit,
    if (legacyBalance != null) 'legacy_balance': legacyBalance,
  };
}
