import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_sub_screen_scaffold.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_shop_invoices_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/widgets/collections/rm_shop_outstanding_content.dart';

class RmShopInvoicesScreen extends GetView<RmShopInvoicesController> {
  const RmShopInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSubScreenScaffold(
      title: AppTexts.rmShopOutstandingTitle,
      body: const RmShopOutstandingContent(),
    );
  }
}
