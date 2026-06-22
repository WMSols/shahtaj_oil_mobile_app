import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/rm_shop_invoices_controller.dart';

class RmShopInvoicesBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RmShopInvoicesController.new);
}
