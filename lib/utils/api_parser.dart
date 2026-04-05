import 'package:dio/dio.dart';

import '../configs/exception.dart';
import '../models/response/paginated_response.dart';

class ApiParser {
  static PaginatedResponse<T> parsePaginatedData<T>(
    Response response, {
    required String listKey,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final responseData = response.data;
    final actualData = responseData['data'];

    if (actualData == null) {
      throw ServerException(responseData['message'] ?? "Lỗi không xác định");
    }

    final List<dynamic> list = actualData[listKey] ?? [];

    return PaginatedResponse<T>(
      data: list.map((item) => fromJson(item as Map<String, dynamic>)).toList(),
      nextCursor: actualData['nextCursor'],
      hasMore: actualData['hasMore'] ?? false,
    );
  }

  static T parseData<T>({
    required Response response,
    required T Function(Map<String, dynamic>) fromJson,
    String? dataKey,
  }) {
    final responseData = response.data;
    final actualData = responseData['data'];

    if (actualData == null) {
      throw ServerException(responseData['message'] ?? "Lỗi không xác định");
    }

    // Nếu có dataKey thì bóc thêm 1 lớp, nếu không thì lấy trực tiếp actualData
    final Map<String, dynamic> targetData =
        (dataKey != null && actualData is Map)
            ? actualData[dataKey] as Map<String, dynamic>
            : actualData as Map<String, dynamic>;

    return fromJson(targetData);
  }

  /// [listKey]: Key chứa mảng (vd: 'bins', 'notifications')
  static List<T> parseListData<T>({
    required Response response,
    required T Function(Map<String, dynamic>) fromJson,
    required String listKey,
  }) {
    final responseData = response.data;
    final actualData = responseData['data'];

    if (actualData == null) {
      throw ServerException(responseData['message'] ?? "Lỗi không xác định");
    }

    if (actualData is Map<String, dynamic> && actualData.containsKey(listKey)) {
      final List<dynamic> list = actualData[listKey];
      return list
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
