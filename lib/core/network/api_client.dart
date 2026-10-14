import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;

import 'package:shahtaj_oil_mobile_app/common/services/auth/auth_service.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_logger.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class ApiClient extends GetxService {
  ApiClient(this._storage, this._session) {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        // Session expiry is returned as 302; do not follow redirects or we
        // never see that status in the interceptor.
        followRedirects: false,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final database = dotenv.env['ODOO_DATABASE'];
          if (database != null && database.isNotEmpty) {
            options.headers['X-Odoo-Database'] = database;
          }

          final token = await _storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode;
          if (status == 302 || status == 401) {
            final onAuthScreen = _isOnAuthScreen;
            if (!onAuthScreen) {
              await _handleSessionExpired();
            }
            // On login/select-role, 401 is usually bad credentials — keep
            // that message. Elsewhere never parse the body for session codes.
            final message = onAuthScreen
                ? (_extractMessage(error.response?.data) ??
                      AppTexts.loginFailed)
                : AppTexts.sessionExpiredPleaseLogin;
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                type: error.type,
                error: ApiException(message: message, statusCode: status),
              ),
            );
            return;
          }
          handler.next(error);
        },
      ),
    );
    _dio.interceptors.add(ApiLogger.interceptor());
  }

  final StorageService _storage;
  final SessionService _session;
  late final Dio _dio;

  bool _handlingSessionExpiry = false;

  String get odooDatabase => dotenv.env['ODOO_DATABASE'] ?? '';

  bool get _isOnAuthScreen {
    final route = Get.currentRoute;
    return route == AppRoutes.login ||
        route == AppRoutes.selectRole ||
        route == AppRoutes.onboarding ||
        route == AppRoutes.splash;
  }

  Future<void> _handleSessionExpired() async {
    if (_handlingSessionExpiry) return;
    _handlingSessionExpiry = true;
    try {
      final role = _session.role.value;
      if (Get.isRegistered<AuthService>()) {
        await Get.find<AuthService>().logout();
      } else {
        await _session.clearSession();
      }

      // Keep role so login can open with the correct OB/DM context.
      if (role != null) {
        await _storage.saveRole(role.name);
        _session.role.value = role;
      }

      AppToast.showError(AppTexts.sessionExpiredPleaseLogin);

      if (!_isOnAuthScreen) {
        if (role != null) {
          Get.offAllNamed(AppRoutes.login, arguments: role);
        } else {
          Get.offAllNamed(AppRoutes.selectRole);
        }
      }
    } finally {
      _handlingSessionExpiry = false;
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _ensureConnectivity();
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  /// Downloads raw bytes from an absolute URL (e.g. shop photo).
  Future<Uint8List> getBytes(String url) async {
    try {
      _ensureConnectivity();
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final data = response.data;
      if (data == null || data.isEmpty) {
        throw ApiException(message: 'Empty image response');
      }
      return Uint8List.fromList(data);
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _ensureConnectivity();
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  /// POST and unwrap Shahtaj `{ ok: true, data: ... }` envelope.
  Future<Map<String, dynamic>> postData(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final response = await post<dynamic>(path, data: data ?? const {});
    return unwrapData(response.data);
  }

  Map<String, dynamic> unwrapData(dynamic raw) {
    if (raw is! Map) {
      throw ApiException(message: 'Unexpected API response');
    }

    final map = Map<String, dynamic>.from(raw);
    if (map.containsKey('ok') && map['ok'] != true) {
      throw ApiException(
        message: map['message']?.toString() ?? 'Request failed',
        data: map,
      );
    }

    final data = map['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data == null) return map;
    return {'value': data};
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _ensureConnectivity();
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      _ensureConnectivity();
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  void _ensureConnectivity() {
    if (!Get.isRegistered<ConnectivityService>()) return;
    Get.find<ConnectivityService>().ensureOnline();
  }

  ApiException _mapException(DioException e) {
    if (e.error is ApiException) {
      return e.error as ApiException;
    }

    final status = e.response?.statusCode;

    // 302 / 401 away from auth: fixed copy, do not parse body JSON.
    if (status == 302 || status == 401) {
      final onAuthScreen = _isOnAuthScreen;
      return ApiException(
        message: onAuthScreen
            ? (_extractMessage(e.response?.data) ?? AppTexts.loginFailed)
            : AppTexts.sessionExpiredPleaseLogin,
        statusCode: status,
      );
    }

    final message = switch (status) {
      403 => AppTexts.forbiddenAccess,
      404 => AppTexts.recordNotFound,
      500 => AppTexts.serverErrorTryAgain,
      _ => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => AppTexts.connectionTimedOut,
        DioExceptionType.connectionError => AppTexts.noInternetConnection,
        _ =>
          _extractMessage(e.response?.data) ??
              e.message ??
              AppTexts.requestFailed,
      },
    };

    return ApiException(message: message, statusCode: status);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
      if (data['arguments'] is List && (data['arguments'] as List).isNotEmpty) {
        return (data['arguments'] as List).first.toString();
      }
    }
    return null;
  }
}
