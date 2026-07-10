import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/role_api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';

class ProfileService extends GetxService {
  ProfileService(this._api, this._session);

  final ApiClient _api;
  final SessionService _session;

  Future<UserModel> fetchCurrentUser() async {
    final role = _session.role.value;
    if (role == null) {
      throw StateError('No active role in session');
    }

    try {
      final response = await _api.get(role.authMePath);
      final data = response.data;
      final payload = _extractUserPayload(data);
      final user = _normalizeUser(
        UserModel.fromJson(payload).withResolvedName(),
        role,
      );
      await _session.updateUser(user);
      return user;
    } catch (_) {
      return _restoreCachedOrMock(role);
    }
  }

  Map<String, dynamic> _extractUserPayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['user'] ?? data['data'] ?? data['profile'];
      if (nested is Map<String, dynamic>) return nested;
      return data;
    }
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final nested = map['user'] ?? map['data'] ?? map['profile'];
      if (nested is Map) return Map<String, dynamic>.from(nested);
      return map;
    }
    return const {};
  }

  UserModel _normalizeUser(UserModel user, UserRole role) {
    if (user.name.trim().isNotEmpty) return user;

    final cached = _session.user.value?.withResolvedName();
    if (cached != null && cached.name.trim().isNotEmpty) {
      return UserModel(
        id: user.id.isNotEmpty ? user.id : cached.id,
        name: cached.name,
        email: user.email.isNotEmpty ? user.email : cached.email,
        phone: user.phone ?? cached.phone,
        role: role,
      );
    }

    return _mockUserForRole(role);
  }

  Future<UserModel> _restoreCachedOrMock(UserRole role) async {
    final cached = _session.user.value?.withResolvedName();
    if (cached != null && cached.name.trim().isNotEmpty) {
      await _session.updateUser(cached);
      return cached;
    }

    final mock = _mockUserForRole(role);
    await _session.updateUser(mock);
    return mock;
  }

  UserModel _mockUserForRole(UserRole role) {
    return switch (role) {
      UserRole.orderBooker => const UserModel(
        id: 'OB-1001',
        name: 'Mubeen Bhatti',
        email: 'mubeen.bhatt@shahtaj.pk',
        phone: '+92 300 1234567',
        role: UserRole.orderBooker,
      ),
      UserRole.deliveryMan => const UserModel(
        id: 'DM-2001',
        name: 'Mubeen Bhatti',
        email: 'mubeen.bhatt@shahtaj.pk',
        phone: '+92 321 7654321',
        role: UserRole.deliveryMan,
      ),
      UserRole.recoveryMan => const UserModel(
        id: 'RM-3001',
        name: 'Mubeen Bhatti',
        email: 'mubeen.bhatt@shahtaj.pk',
        phone: '+92 333 9876543',
        role: UserRole.recoveryMan,
      ),
    };
  }
}
