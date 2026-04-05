import 'package:dio/dio.dart';

import 'exception.dart';

class ApiErrorHandler {
  static AppException handle(dynamic error) {
    if (error is DioException) {

      // network error
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return NetworkException();
      }

      // server error
      final message = error.response?.data?['message'];

      return ServerException(
        message ?? "Lỗi từ server", // ✅ tránh null
      );
    }

    if (error is AppException) return error;

    return UnknownException(error.toString());
  }
}