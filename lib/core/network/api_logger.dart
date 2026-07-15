import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Debug-only colored API request/response logging for the console.
class ApiLogger {
  ApiLogger._();

  static const _reset = '\x1B[0m';
  static const _cyan = '\x1B[36m';
  static const _green = '\x1B[32m';
  static const _red = '\x1B[31m';
  static const _yellow = '\x1B[33m';
  static const _magenta = '\x1B[35m';
  static const _dim = '\x1B[2m';

  static Interceptor interceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          final method = options.method.toUpperCase();
          final uri = options.uri;
          _print('$_cyan▶ REQUEST$_reset $_magenta$method$_reset $uri');
          if (options.headers.isNotEmpty) {
            _print('$_dim  headers: ${_safeJson(options.headers)}$_reset');
          }
          if (options.data != null) {
            _print('$_dim  body: ${_safeJson(options.data)}$_reset');
          }
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          final status = response.statusCode ?? 0;
          final ok = status >= 200 && status < 300;
          final color = ok ? _green : _yellow;
          final label = ok ? 'SUCCESS' : 'RESPONSE';
          _print(
            '$color◀ $label$_reset $_magenta${response.requestOptions.method.toUpperCase()}$_reset '
            '${response.requestOptions.uri} [$status]',
          );
          _print('$color  data: ${_safeJson(response.data)}$_reset');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          final status = error.response?.statusCode;
          _print(
            '$_red✖ ERROR$_reset $_magenta${error.requestOptions.method.toUpperCase()}$_reset '
            '${error.requestOptions.uri}'
            '${status != null ? ' [$status]' : ''}',
          );
          if (error.response?.data != null) {
            _print('$_red  data: ${_safeJson(error.response?.data)}$_reset');
          } else {
            _print('$_red  message: ${error.message}$_reset');
          }
        }
        handler.next(error);
      },
    );
  }

  static void _print(String message) {
    // ignore: avoid_print
    print(message);
  }

  static String _safeJson(dynamic value) {
    try {
      if (value is Map) {
        return const JsonEncoder.withIndent('  ').convert(_redact(value));
      }
      if (value is List) {
        return const JsonEncoder.withIndent('  ').convert(value);
      }
      if (value is String) return value;
      return value.toString();
    } catch (_) {
      return value.toString();
    }
  }

  static dynamic _redact(dynamic value) {
    if (value is Map) {
      return value.map((key, entry) {
        final keyName = key.toString().toLowerCase();
        if (keyName.contains('password') ||
            keyName.contains('token') ||
            keyName.contains('authorization') ||
            keyName.contains('api_key')) {
          return MapEntry(key, '***');
        }
        return MapEntry(key, _redact(entry));
      });
    }
    if (value is List) return value.map(_redact).toList();
    return value;
  }
}
