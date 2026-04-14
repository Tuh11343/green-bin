import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenbin/services/http/dio_client.dart';
import 'package:greenbin/utils/api_parser.dart';

import '../../configs/api_endpoint.dart';
import '../../configs/api_error_handle.dart';
import '../../configs/exception.dart';
import '../../models/bin.dart';
import '../../models/collection_task.dart';

class BinApi {
  final DioClient _dioClient = DioClient();

  Future<List<Bin>> getAllBins() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getAllBins,
      );

      return ApiParser.parseListData(response: response,fromJson: Bin.fromJson,listKey: 'bins');
    } catch (e) {
      debugPrint('Lỗi:${e.toString()}');
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
