class ApiException implements Exception {
  ApiException({required this.message, this.statusCode, this.data});

  final String message;
  final int? statusCode;
  final dynamic data;

  bool get isSessionExpired => statusCode == 302 || statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode == 500;

  @override
  String toString() =>
      'ApiException($statusCode): $message${data != null ? ' - $data' : ''}';
}
