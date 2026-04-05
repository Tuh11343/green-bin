abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException([String? message])
      : super(message ?? "Lỗi máy chủ, vui lòng thử lại");
}

class NetworkException extends AppException {
  NetworkException([String? message])
      : super(message ?? "Không có kết nối mạng hoặc lỗi server");
}

class UnknownException extends AppException {
  UnknownException([String? message])
      : super(message ?? "Có lỗi không xác định xảy ra");
}