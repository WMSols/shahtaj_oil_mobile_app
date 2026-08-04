import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/services/account/profile_service.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/layout/app_drawer_entry.dart';

abstract class AppShellController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RxString selectedLeafId = ''.obs;
  final RxSet<String> expandedGroupIds = <String>{}.obs;

  static const _exitConfirmWindow = Duration(seconds: 2);
  DateTime? _lastBackAt;

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

  /// First drawer leaf is always the role dashboard / home.
  String get homeLeafId => allLeaves.isEmpty ? '' : allLeaves.first.id;

  bool get isOnHome =>
      homeLeafId.isNotEmpty && selectedLeafId.value == homeLeafId;

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

  /// Handles Android/iOS system back while a drawer leaf is showing.
  ///
  /// Returns `true` when the shell route should pop (exit the app module).
  bool handleSystemBack() {
    final scaffold = scaffoldKey.currentState;
    if (scaffold?.isDrawerOpen ?? false) {
      scaffold!.closeDrawer();
      return false;
    }

    if (!isOnHome) {
      selectLeaf(homeLeafId);
      _lastBackAt = null;
      return false;
    }

    final now = DateTime.now();
    if (_lastBackAt == null ||
        now.difference(_lastBackAt!) > _exitConfirmWindow) {
      _lastBackAt = now;
      AppToast.showInformation(AppTexts.pressBackAgainToExit);
      return false;
    }

    _lastBackAt = null;
    return true;
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
