import 'package:dio/dio.dart';
import 'package:greenbin/configs/api_endpoint.dart';

import 'auth_interceptor.dart';
import 'error_interceptor.dart';


class DioClient {
  static final DioClient _instance = DioClient._internal();

  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
  }

  /// Base options cho tất cả requests
  static BaseOptions get _baseOptions => BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(
      seconds: ApiEndpoints.timeOut,
    ),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );

  /// Setup tất cả interceptors
  void _setupInterceptors() {
    // // Logging interceptor (chỉ trong development)
    // if (kDebugMode) {
    //   _dio.interceptors.add(LoggingInterceptor());
    // }

    // Auth interceptor
    _dio.interceptors.add(AuthInterceptor());

    // Error interceptor
    _dio.interceptors.add(ErrorInterceptor());
  }

  /// Lấy Dio instance
  Dio get dio => _dio;

  /// GET request
  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch(err){
      rethrow;
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch(err){
      rethrow;
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch(err) {
      rethrow;
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch(err) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    }catch(err){
      rethrow;
    }
  }

  /// Download file
  Future<Response> download(
      String urlPath,
      String savePath, {
        ProgressCallback? onReceiveProgress,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        bool deleteOnError = true,
        String lengthHeader = Headers.contentLengthHeader,
        dynamic data,
        Options? options,
      }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
      return response;
    } catch(err) {
      rethrow;
    }
  }

  /// Upload file với FormData
  Future<Response<T>> upload<T>(
      String path, {
        required FormData formData,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch(err) {
      rethrow;
    }
  }

  void setConnectTimeout(Duration duration) {
    _dio.options.connectTimeout = duration;
  }

  void setReceiveTimeout(Duration duration) {
    _dio.options.receiveTimeout = duration;
  }

  void setSendTimeout(Duration duration) {
    _dio.options.sendTimeout = duration;
  }

  void reset() {
    _dio.close(force: true);
  }
}