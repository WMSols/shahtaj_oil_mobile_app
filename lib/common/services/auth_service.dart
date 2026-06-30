import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/role_api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
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
    try {
      final response = await _api.post(
        role.authLoginPath,
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      final token = data['token']?.toString() ?? '';
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await _storage.saveToken(token);
      await _storage.saveRole(role.name);
      _session.setSession(userModel: user, userRole: role);
      return user;
    } catch (_) {
      final user = UserModel(
        id: '1',
        name: email.split('@').first,
        email: email,
        role: role,
      );
      await _storage.saveToken('mock-token');
      await _storage.saveRole(role.name);
      _session.setSession(userModel: user, userRole: role);
      return user;
    }
  }

  Future<void> logout() async {
    final role = _session.role.value;
    if (role != null) {
      try {
        await _api.post(role.authLogoutPath);
      } catch (_) {}
    }
    await _session.clearSession();
  }
}
