import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/role_api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/services/presence_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

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
    if (role != UserRole.orderBooker) {
      throw ApiException(
        message: 'API login is only available for Order Booker right now.',
      );
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

  Future<void> logout() async {
    // No logout endpoint in Shahtaj v1 yet — clear local session only.
    final role = _session.role.value;
    if (role != null && role != UserRole.orderBooker) {
      try {
        await _api.post(role.authLogoutPath);
      } catch (_) {}
    }
    await _session.clearSession();
  }
}
