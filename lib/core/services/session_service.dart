import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class SessionService extends GetxService {
  SessionService(this._storage);

  final StorageService _storage;

  final Rxn<UserModel> user = Rxn<UserModel>();
  final Rxn<UserRole> role = Rxn<UserRole>();

  bool get isLoggedIn => user.value != null;

  Future<SessionService> init() async {
    final token = await _storage.getToken();
    final roleStr = await _storage.getRole();
    if (token != null && roleStr != null) {
      role.value = UserRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => UserRole.orderBooker,
      );
    }
    return this;
  }

  void setSession({required UserModel userModel, required UserRole userRole}) {
    user.value = userModel;
    role.value = userRole;
  }

  Future<void> clearSession() async {
    user.value = null;
    role.value = null;
    await _storage.clearAll();
  }
}
