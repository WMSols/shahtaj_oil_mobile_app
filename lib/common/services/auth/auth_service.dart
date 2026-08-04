import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/account/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/presence_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_cart_service.dart';

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
    // DM: UI-only mock session — no API until that module is wired.
    // RM never reaches here (blocked in AuthController).
    if (role == UserRole.deliveryMan) {
      return _loginUiOnly(email: email, role: role);
    }

    if (role != UserRole.orderBooker) {
      throw ApiException(message: 'This module is under development.');
    }

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

  Future<void> logout() async {
    // No logout endpoint in Shahtaj v1 yet — clear local session only.
    // Skip API for non-OB (UI-only mock sessions).
    if (Get.isRegistered<OfflineCacheService>()) {
      await Get.find<OfflineCacheService>().clearOrderBookerSessionCache();
    }
    if (Get.isRegistered<ObTaskService>()) {
      await Get.delete<ObTaskService>(force: true);
    }
    if (Get.isRegistered<ObVisitCartService>()) {
      await Get.delete<ObVisitCartService>(force: true);
    }
    await _session.clearSession();
  }
}
