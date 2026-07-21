import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';

class StorageService {
  static const _tokenKey = 'auth_token';
  static const _roleKey = 'user_role';
  static const _userKey = 'user_profile';
  static const _localeKey = 'app_locale';
  static const _onboardingCompletedKey = 'onboarding_completed';
  static const _readTimeout = Duration(seconds: 5);

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    wOptions: WindowsOptions(useBackwardCompatibility: false),
  );

  Future<String?> getToken() => _read(_tokenKey);

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<String?> getRole() => _read(_roleKey);

  Future<void> saveRole(String role) =>
      _storage.write(key: _roleKey, value: role);

  Future<void> clearRole() => _storage.delete(key: _roleKey);

  Future<String?> getUser() => _read(_userKey);

  Future<void> saveUser(String userJson) =>
      _storage.write(key: _userKey, value: userJson);

  Future<void> clearUser() => _storage.delete(key: _userKey);

  Future<String?> getLocale() => _read(_localeKey);

  Future<void> saveLocale(String code) =>
      _storage.write(key: _localeKey, value: code);

  Future<bool> isOnboardingCompleted() async {
    final value = await _read(_onboardingCompletedKey);
    return value == 'true';
  }

  Future<void> setOnboardingCompleted() =>
      _storage.write(key: _onboardingCompletedKey, value: 'true');

  // ── Remember me (per role) ──────────────────────────────────────────────

  String _rememberFlagKey(UserRole role) => 'remember_me_${role.name}';
  String _rememberLoginKey(UserRole role) => 'remember_login_${role.name}';
  String _rememberPasswordKey(UserRole role) =>
      'remember_password_${role.name}';

  Future<bool> isRememberMeEnabled(UserRole role) async {
    final value = await _read(_rememberFlagKey(role));
    return value == 'true';
  }

  Future<String?> getRememberedLogin(UserRole role) =>
      _read(_rememberLoginKey(role));

  Future<String?> getRememberedPassword(UserRole role) =>
      _read(_rememberPasswordKey(role));

  Future<void> saveRememberedCredentials({
    required UserRole role,
    required String login,
    required String password,
  }) async {
    await _storage.write(key: _rememberFlagKey(role), value: 'true');
    await _storage.write(key: _rememberLoginKey(role), value: login);
    await _storage.write(key: _rememberPasswordKey(role), value: password);
  }

  Future<void> clearRememberedCredentials(UserRole role) async {
    await _storage.delete(key: _rememberFlagKey(role));
    await _storage.delete(key: _rememberLoginKey(role));
    await _storage.delete(key: _rememberPasswordKey(role));
  }

  /// Clears auth session keys only — keeps locale, onboarding, and remember-me.
  Future<void> clearSessionData() async {
    await clearToken();
    await clearRole();
    await clearUser();
  }

  Future<void> clearAll() => _storage.deleteAll();

  Future<String?> readValue(String key) => _read(key);

  Future<void> writeValue(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> deleteValue(String key) => _storage.delete(key: key);

  Future<String?> _read(String key) =>
      _storage.read(key: key).timeout(_readTimeout, onTimeout: () => null);
}
