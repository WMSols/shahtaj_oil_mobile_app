import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/account/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/models/gps_criteria.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/presence_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/sync/ob_day_bootstrap_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/shops/ob_shop_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_cart_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_session_service.dart';

class AuthService extends GetxService {
  AuthService(this._api, this._storage, this._session);

  final ApiClient _api;
  final StorageService _storage;
  final SessionService _session;

  Future<UserModel> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    // Delivery Man: UI-only mock session — no API until modules are wired.
    if (role == UserRole.deliveryMan) {
      return _loginUiOnly(email: email, role: role);
    }

    // Re-enable to block non-OB at the service layer.
    // if (role != UserRole.orderBooker) {
    //   throw ApiException(message: 'This module is under development.');
    // }

    final database = _api.odooDatabase;
    if (database.isEmpty) {
      throw ApiException(message: 'ODOO_DATABASE is not configured.');
    }

    final data = await _api.postData(
      ApiEndpoints.obAuthLogin,
      data: {'database': database, 'login': email.trim(), 'password': password},
    );

    final apiKey = data['api_key']?.toString() ?? '';
    if (apiKey.isEmpty) {
      throw ApiException(
        message: 'Login succeeded but no API key was returned.',
      );
    }

    final userJson = data['user'];
    if (userJson is! Map) {
      throw ApiException(
        message: 'Login succeeded but user payload was missing.',
      );
    }

    final user = UserModel.fromJson(Map<String, dynamic>.from(userJson))
        .copyWith(role: role, presenceStatus: PresenceStatus.online)
        .withResolvedName();

    await _storage.saveToken(apiKey);
    await _storage.saveRole(role.name);
    await _session.setSession(userModel: user, userRole: role);
    final gps = GpsCriteria.tryParse(data['gps_criteria']);
    if (gps != null) {
      await _session.setGpsCriteria(gps);
    }
    await _reconcileLocalDataOwner(user.id);

    if (Get.isRegistered<PresenceService>()) {
      unawaited(Get.find<PresenceService>().markOnlineNow());
    }

    return user;
  }

  /// Local session for Delivery Man while UI is built without APIs.
  Future<UserModel> _loginUiOnly({
    required String email,
    required UserRole role,
  }) async {
    final trimmed = email.trim();
    final display = trimmed.isEmpty ? 'Delivery Man' : trimmed.split('@').first;

    final user = UserModel(
      id: 'ui-${role.name}',
      name: display,
      email: trimmed.isEmpty ? '${role.name}@shahtaj.local' : trimmed,
      role: role,
      presenceStatus: PresenceStatus.online,
    ).withResolvedName();

    await _storage.saveToken('ui-mock-token-${role.name}');
    await _storage.saveRole(role.name);
    await _session.setSession(userModel: user, userRole: role);
    return user;
  }

  /// Logout clears the session only.
  ///
  /// Queued work, local visits, offline shops, carts and captured photos stay
  /// on the device so a day's field work survives a logout and resumes when
  /// the same booker signs back in. Snapshots are only dropped when a
  /// *different* user signs in (see [_reconcileLocalDataOwner]).
  Future<void> logout() async {
    // No logout endpoint in Shahtaj v1 yet — clear local session only.
    if (Get.isRegistered<ObTaskService>()) {
      await Get.delete<ObTaskService>(force: true);
    }
    if (Get.isRegistered<ObVisitCartService>()) {
      await Get.delete<ObVisitCartService>(force: true);
    }
    if (Get.isRegistered<ObVisitSessionService>()) {
      await Get.delete<ObVisitSessionService>(force: true);
    }
    if (Get.isRegistered<ObDayBootstrapService>()) {
      await Get.delete<ObDayBootstrapService>(force: true);
    }
    if (Get.isRegistered<ObShopService>()) {
      Get.find<ObShopService>().clearSessionMemory();
      await Get.delete<ObShopService>(force: true);
    }
    await _session.clearSession();
  }

  /// Keeps one booker's offline data from ever showing up for another.
  ///
  /// The previous user's queued work and local visits stay on disk so they can
  /// resume after signing back in. Reads are scoped by user id; on switch we
  /// only wipe shared snapshots / task overrides that are not user-stamped.
  Future<void> _reconcileLocalDataOwner(String userId) async {
    if (userId.isEmpty) return;
    final previous = await _storage.getLocalDataOwner();

    if (Get.isRegistered<AppDatabase>()) {
      final db = Get.find<AppDatabase>();
      if (previous != null && previous.isNotEmpty && previous != userId) {
        // Stamp null-owner rows to the outgoing booker before switching.
        await db.claimOrphanLocalOwnership(previous);
        if (Get.isRegistered<OfflineCacheService>()) {
          await Get.find<OfflineCacheService>().clearOrderBookerSessionCache();
        }
        await db.clearSnapshots();
        await db.clearTaskOverrides();
        if (Get.isRegistered<ObShopService>()) {
          Get.find<ObShopService>().clearSessionMemory();
        }
        // Keep visit carts/products on disk — they stay keyed to visit ids and
        // only surface when that booker's visit is active again.
      } else {
        // Same booker (or first owner): orphans belong to them.
        await db.claimOrphanLocalOwnership(userId);
      }
    } else if (previous != null && previous != userId) {
      if (Get.isRegistered<OfflineCacheService>()) {
        await Get.find<OfflineCacheService>().clearOrderBookerSessionCache();
      }
    }

    await _storage.saveLocalDataOwner(userId);
    if (Get.isRegistered<SyncOutboxService>()) {
      await Get.find<SyncOutboxService>().refreshPendingCount();
    }
  }
}
