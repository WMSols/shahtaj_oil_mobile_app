import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;

import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_logger.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

class ApiClient extends GetxService {
  ApiClient(this._storage, this._session) {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
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
          if (error.response?.statusCode == 401) {
            await _session.clearSession();
            if (Get.currentRoute != AppRoutes.login &&
                Get.currentRoute != AppRoutes.selectRole) {
              Get.offAllNamed(AppRoutes.selectRole);
            }
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

  String get odooDatabase => dotenv.env['ODOO_DATABASE'] ?? '';

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
    final status = e.response?.statusCode;
    final data = e.response?.data;
    final message = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => 'Connection timed out',
      DioExceptionType.connectionError => 'No internet connection',
      _ => _extractMessage(data) ?? e.message ?? 'Request failed',
    };
    return ApiException(message: message, statusCode: status, data: data);
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
