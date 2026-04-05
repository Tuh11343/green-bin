import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../app_secure_storage.dart';


/// Interceptor để xử lý các lỗi HTTP
/// Xử lý tất cả status codes và DioException types
class ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    // Log error type
    debugPrint('🔴 [ErrorInterceptor] Error Type: ${err.type}');
    debugPrint('🔴 [ErrorInterceptor] Status Code: ${err.response?.statusCode}');

    // Xử lý theo status code
    if (err.response != null) {
      switch (err.response?.statusCode) {
        case 400:
          return _handleBadRequest(err, handler);
        case 401:
          return _handleUnauthorized(err, handler);
        case 403:
          return _handleForbidden(err, handler);
        case 404:
          return _handleNotFound(err, handler);
        case 409:
          return _handleConflict(err, handler);
        case 429:
          return _handleTooManyRequests(err, handler);
        case 500:
          return _handleServerError(err, handler);
        case 503:
          return _handleServiceUnavailable(err, handler);
        default:
          return _handleOtherStatusCode(err, handler);
      }
    }

    // Xử lý theo error type (khi không có response)
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return _handleConnectionTimeout(err, handler);
      case DioExceptionType.sendTimeout:
        return _handleSendTimeout(err, handler);
      case DioExceptionType.receiveTimeout:
        return _handleReceiveTimeout(err, handler);
      case DioExceptionType.badResponse:
        return _handleBadResponse(err, handler);
      case DioExceptionType.cancel:
        return _handleCancel(err, handler);
      case DioExceptionType.unknown:
        return _handleUnknownError(err, handler);
      default:
        return handler.next(err);
    }
  }

  // ====================== HTTP STATUS CODE HANDLERS ======================

  /// 400 Bad Request - Yêu cầu không hợp lệ
  void _handleBadRequest(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    final message = _extractErrorMessage(err) ?? 'Yêu cầu không hợp lệ';
    debugPrint('⚠️ [400 Bad Request] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      error: 'Bad Request: $message',
    );
    handler.reject(customErr);
  }

  /// 401 Unauthorized - Token hết hạn hoặc không hợp lệ
  Future<void> _handleUnauthorized(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    debugPrint('🔐 [401 Unauthorized] Token hết hạn hoặc không hợp lệ');

    // Xóa token khỏi storage
    await AppStorage.clearAll();

    // TODO: Điều hướng đến màn hình login
    // Bạn có thể dùng GetIt hoặc NavigationService
    // GetIt.instance<NavigationService>().navigateToLogin();

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      error: 'Unauthorized: Vui lòng đăng nhập lại',
    );
    handler.reject(customErr);
  }

  /// 403 Forbidden - Không có quyền truy cập
  void _handleForbidden(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Bạn không có quyền truy cập tài nguyên này';
    debugPrint('🚫 [403 Forbidden] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      error: 'Forbidden: $message',
    );
    handler.reject(customErr);
  }

  /// 404 Not Found - Không tìm thấy tài nguyên
  void _handleNotFound(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Tài nguyên không được tìm thấy';
    debugPrint('🔍 [404 Not Found] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      error: 'Not Found: $message',
    );
    handler.reject(customErr);
  }

  /// 409 Conflict - Xung đột dữ liệu
  void _handleConflict(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    final message = _extractErrorMessage(err) ?? 'Xung đột dữ liệu';
    debugPrint('⚡ [409 Conflict] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      error: 'Conflict: $message',
    );
    handler.reject(customErr);
  }

  /// 429 Too Many Requests - Quá nhiều yêu cầu
  void _handleTooManyRequests(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Quá nhiều yêu cầu. Vui lòng thử lại sau';
    debugPrint('⏱️ [429 Too Many Requests] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      error: 'Too Many Requests: $message',
    );
    handler.reject(customErr);
  }

  /// 500 Internal Server Error - Lỗi máy chủ
  void _handleServerError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Lỗi máy chủ. Vui lòng thử lại sau';
    debugPrint('❌ [500 Server Error] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      error: 'Server Error: $message',
    );
    handler.reject(customErr);
  }

  /// 503 Service Unavailable - Dịch vụ không khả dụng
  void _handleServiceUnavailable(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Dịch vụ không khả dụng. Vui lòng thử lại sau';
    debugPrint('🛑 [503 Service Unavailable] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.badResponse,
      error: 'Service Unavailable: $message',
    );
    handler.reject(customErr);
  }

  /// Các status code khác
  void _handleOtherStatusCode(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    final statusCode = err.response?.statusCode ?? 'Unknown';
    debugPrint('⚠️ [Error] Status Code: $statusCode');

    handler.next(err);
  }

  // ====================== ERROR TYPE HANDLERS ======================

  /// Connection Timeout - Kết nối hết thời gian chờ
  void _handleConnectionTimeout(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Kết nối hết thời gian chờ. Kiểm tra kết nối mạng của bạn';
    debugPrint('⏳ [Connection Timeout] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.connectionTimeout,
      error: message,
    );
    handler.reject(customErr);
  }

  /// Send Timeout - Gửi dữ liệu hết thời gian chờ
  void _handleSendTimeout(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Gửi dữ liệu hết thời gian chờ';
    debugPrint('⏳ [Send Timeout] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.sendTimeout,
      error: message,
    );
    handler.reject(customErr);
  }

  /// Receive Timeout - Nhận dữ liệu hết thời gian chờ
  void _handleReceiveTimeout(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Nhận dữ liệu hết thời gian chờ';
    debugPrint('⏳ [Receive Timeout] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.receiveTimeout,
      error: message,
    );
    handler.reject(customErr);
  }

  /// Bad Response - Phản hồi không hợp lệ
  void _handleBadResponse(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    const message = 'Phản hồi không hợp lệ từ máy chủ';
    debugPrint('❌ [Bad Response] $message');

    handler.next(err);
  }

  /// Cancel - Yêu cầu bị hủy
  void _handleCancel(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    debugPrint('❌ [Cancel] Yêu cầu bị hủy');
    handler.next(err);
  }

  /// Unknown Error - Lỗi không xác định
  void _handleUnknownError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    final message = err.error?.toString() ?? 'Lỗi không xác định';
    debugPrint('❓ [Unknown Error] $message');

    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: DioExceptionType.unknown,
      error: message,
    );
    handler.reject(customErr);
  }

  // ====================== HELPER METHODS ======================

  /// Trích xuất error message từ response JSON
  String? _extractErrorMessage(DioException err) {
    try {
      final data = err.response?.data;

      if (data is Map<String, dynamic>) {
        // Thử các tên field phổ biến
        return data['message'] as String? ??
            data['error'] as String? ??
            data['msg'] as String? ??
            (data['errors'] is List && (data['errors'] as List).isNotEmpty
                ? data['errors'][0] as String?
                : null);
      }

      return null;
    } catch (e) {
      debugPrint('⚠️ [ErrorInterceptor] Error extracting message: $e');
      return null;
    }
  }
}