import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
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

    if (role != UserRole.orderBooker) {
      final cached = _session.user.value;
      if (cached != null) return cached;
      throw ApiException(
        message: 'Profile API is not available for this role.',
      );
    }

    try {
      final data = await _api.postData(ApiEndpoints.obAuthMe);
      final userJson = data['user'];
      if (userJson is! Map) {
        throw ApiException(message: 'Profile payload was missing.');
      }

      final user = UserModel.fromJson(Map<String, dynamic>.from(userJson))
          .copyWith(
            role: role,
            presenceStatus: PresenceStatusX.fromApi(data['online_status']),
          )
          .withResolvedName();
      await _session.updateUser(user);
      return user;
    } catch (_) {
      final cached = _session.user.value?.withResolvedName();
      if (cached != null && cached.name.trim().isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }
}
