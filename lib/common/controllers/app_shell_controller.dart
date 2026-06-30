import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer.dart';

abstract class AppShellController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RxInt currentIndex = 0.obs;

  List<AppDrawerItem> get drawerItems;

  AppDrawerItem get currentItem => drawerItems[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    for (final item in drawerItems) {
      item.initBinding?.call();
    }
  }

  void selectIndex(int index) {
    if (index < 0 || index >= drawerItems.length) return;
    currentIndex.value = index;
    scaffoldKey.currentState?.closeDrawer();
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();
}
