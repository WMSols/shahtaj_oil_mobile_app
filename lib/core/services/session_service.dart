import 'dart:convert';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/account/user_model.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/models/gps_criteria.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class SessionService extends GetxService {
  SessionService(this._storage);

  final StorageService _storage;

  final Rxn<UserModel> user = Rxn<UserModel>();
  final Rxn<UserRole> role = Rxn<UserRole>();
  final Rxn<GpsCriteria> gpsCriteria = Rxn<GpsCriteria>();

  bool get isLoggedIn => user.value != null;

  /// Effective place-order / check-in max distance (meters), or null if unknown.
  double? get shopActionMaxDistanceMeters => gpsCriteria.value?.maxM;

  Future<SessionService> init() async {
    final token = await _storage.getToken();
    final roleStr = await _storage.getRole();
    if (token != null && roleStr != null) {
      role.value = UserRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => UserRole.orderBooker,
      );
    }

    final userJson = await _storage.getUser();
    if (userJson != null) {
      try {
        user.value = UserModel.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
      } catch (_) {
        user.value = null;
      }
    }

    final gpsJson = await _storage.getGpsCriteria();
    if (gpsJson != null) {
      try {
        gpsCriteria.value = GpsCriteria.fromJson(
          jsonDecode(gpsJson) as Map<String, dynamic>,
        );
      } catch (_) {
        gpsCriteria.value = null;
      }
    }

    return this;
  }

  Future<void> setSession({
    required UserModel userModel,
    required UserRole userRole,
  }) async {
    user.value = userModel;
    role.value = userRole;
    await _storage.saveUser(jsonEncode(userModel.toJson()));
  }

  Future<void> updateUser(UserModel userModel) async {
    user.value = userModel;
    await _storage.saveUser(jsonEncode(userModel.toJson()));
  }

  Future<void> setGpsCriteria(GpsCriteria? criteria) async {
    gpsCriteria.value = criteria;
    if (criteria == null) {
      await _storage.clearGpsCriteria();
      return;
    }
    await _storage.saveGpsCriteria(jsonEncode(criteria.toJson()));
  }

  Future<void> clearSession() async {
    user.value = null;
    role.value = null;
    gpsCriteria.value = null;
    await _storage.clearSessionData();
  }
}
