import 'package:shahtaj_oil_mobile_app/core/design/images/app_images.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/rm_targets_model.dart';

/// Mock payloads still used by DM/RM dashboard stubs.
/// Order Booker uses live APIs + [OfflineCacheService].
class AppMockData {
  AppMockData._();

  static List<DmStockItemModel> get dmStockItems => const [
    DmStockItemModel(
      id: 'stock-001',
      name: 'Shahtaj Cooking Oil 5L',
      quantity: 45,
      unit: 'Bottles',
      isLowStock: true,
      imageAsset: AppImages.onboardingIntro,
    ),
    DmStockItemModel(
      id: 'stock-002',
      name: 'Shahtaj Banaspati Ghee 16kg',
      quantity: 120,
      unit: 'Tins',
      imageAsset: AppImages.onboardingLanguage,
    ),
    DmStockItemModel(
      id: 'stock-003',
      name: 'Shahtaj Cooking Oil 1L',
      quantity: 12,
      unit: 'Pouches',
      isLowStock: true,
      imageAsset: AppImages.onboardingRole,
    ),
  ];

  static int get dmVanStockCount => 24;

  static RmTargetsModel get rmTargets =>
      const RmTargetsModel(recoveryCurrent: 145000, recoveryTarget: 250000);
}
