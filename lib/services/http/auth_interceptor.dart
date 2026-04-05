import 'package:dio/dio.dart';
import 'package:greenbin/configs/api_endpoint.dart';

import '../app_secure_storage.dart';


class AuthInterceptor extends Interceptor {
  /// Danh sách endpoints không cần token
  static const List<String> _publicEndpoints = [
    ApiEndpoints.nominatimSearch,
    ApiEndpoints.nominatimReverse,
    ApiEndpoints.login,
    ApiEndpoints.register,
    ApiEndpoints.forgotPassword,
    ApiEndpoints.resetPassword,
    ApiEndpoints.changePassword,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.resendOtp,
    ApiEndpoints.googleSignIn,
    ApiEndpoints.logout,
  ];

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      if (_requiresAuth(options.path)) {
        final token = await AppStorage.getToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.unknown,
              error: 'Unauthorized: No token available',
            ),
          );
        }
      }

      // Thêm common headers
      _addCommonHeaders(options);

      return handler.next(options);
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: 'Auth interceptor error: $e',
        ),
      );
    }
  }

  /// Kiểm tra endpoint có cần token không
  bool _requiresAuth(String path) {
    return !_publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  /// Thêm các headers chung cho tất cả requests
  void _addCommonHeaders(RequestOptions options) {
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-API-Version': '1.0',
    });
  }
}