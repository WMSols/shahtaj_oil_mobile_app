import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_shop_invoices_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/widgets/collections/dm_shop_outstanding_content.dart';

class DmShopInvoicesScreen extends GetView<DmShopInvoicesController> {
  const DmShopInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.dmShopOutstandingTitle,
      body: const DmShopOutstandingContent(),
    );
  }
}
