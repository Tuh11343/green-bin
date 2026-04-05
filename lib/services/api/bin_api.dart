import 'package:dio/dio.dart';
import 'package:greenbin/services/http/dio_client.dart';

import '../../configs/api_endpoint.dart';
import '../../configs/api_error_handle.dart';
import '../../configs/exception.dart';
import '../../models/bin.dart';
import '../../models/collection_task.dart';

class BinApi {
  final DioClient _dioClient = DioClient();

  T _parseData<T>(
      Response response,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    final responseData = response.data;

    final actualData = responseData['data'];

    if (actualData == null) {
      throw ServerException(responseData['message']);
    }

    if (actualData is Map<String, dynamic> &&
        actualData.containsKey('bin')) {
      return fromJson(actualData['bin'] as Map<String, dynamic>);
    }

    return fromJson(actualData as Map<String, dynamic>);
  }

  List<T> _parseListData<T>(
      Response response,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    final responseData = response.data;
    final actualData = responseData['data'];

    if (actualData == null) {
      throw ServerException(responseData['message'] ?? "Lỗi không xác định");
    }

    if (actualData is Map<String, dynamic> &&
        actualData.containsKey('bins')) {
      final List<dynamic> list = actualData['bins'];
      return list
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }


  Future<List<Bin>> getAllBins() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getAllBins,
      );

      return _parseListData(response, Bin.fromJson);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<Bin>> getUnCollectedBin() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getUnCollectedBin,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> listData = response.data!['data'];

        return listData.map((json) => Bin.fromJson(json)).toList();
      } else {
        throw Exception('Submit Task failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }


}
