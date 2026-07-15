import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/services/profile_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';

abstract class AppShellController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RxString selectedLeafId = ''.obs;
  final RxSet<String> expandedGroupIds = <String>{}.obs;

  List<AppDrawerEntry> get drawerEntries;

  List<AppDrawerLeaf> get allLeaves {
    final leaves = <AppDrawerLeaf>[];
    for (final entry in drawerEntries) {
      if (entry.isGroup) {
        leaves.addAll(entry.children!);
      } else if (entry.leaf != null) {
        leaves.add(entry.leaf!);
      }
    }
    return leaves;
  }

  AppDrawerLeaf get currentLeaf => allLeaves.firstWhere(
    (leaf) => leaf.id == selectedLeafId.value,
    orElse: () => allLeaves.first,
  );

  @override
  void onInit() {
    super.onInit();
    final leaves = allLeaves;
    if (leaves.isEmpty) return;

    selectedLeafId.value = leaves.first.id;
    _expandParentOf(leaves.first.id);

    for (final leaf in leaves) {
      leaf.initBinding?.call();
    }

    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (!Get.isRegistered<ProfileService>()) return;

    final session = Get.find<SessionService>();
    if (session.role.value == null) return;

    try {
      await Get.find<ProfileService>().fetchCurrentUser();
    } catch (_) {}
  }

  void selectLeaf(String id) {
    if (!allLeaves.any((leaf) => leaf.id == id)) return;

    final leaf = allLeaves.firstWhere((item) => item.id == id);
    leaf.initBinding?.call();

    selectedLeafId.value = id;
    _expandParentOf(id);
    scaffoldKey.currentState?.closeDrawer();
  }

  void openAccount() {
    final accountLeaf = allLeaves.where((leaf) => leaf.id.endsWith('_account'));
    if (accountLeaf.isEmpty) return;
    selectLeaf(accountLeaf.first.id);
  }

  void toggleGroup(String groupId) {
    if (expandedGroupIds.contains(groupId)) {
      expandedGroupIds.remove(groupId);
    } else {
      expandedGroupIds.add(groupId);
    }
  }

  bool isGroupExpanded(String groupId) => expandedGroupIds.contains(groupId);

  bool isGroupActive(AppDrawerEntry entry) {
    if (!entry.isGroup) return false;
    return entry.children!.any((child) => child.id == selectedLeafId.value);
  }

  void _expandParentOf(String leafId) {
    for (final entry in drawerEntries) {
      if (entry.isGroup && entry.children!.any((child) => child.id == leafId)) {
        expandedGroupIds.add(entry.id);
      }
    }
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();
}
