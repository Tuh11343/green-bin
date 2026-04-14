import 'package:dio/dio.dart';
import 'package:greenbin/configs/api_error_handle.dart';

import '../../models/search_result_map/search_result.dart';
import '../http/dio_client.dart';

class GoogleMapApi {
  final DioClient _dioClient = DioClient();
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  // Tìm kiếm theo tên
  Future<List<SearchResult>> searchLocation({
    required String query,
    int limit = 5,
    String? countryCode,
    String? viewbox,
  }) async {
    try{
      final response = await _dioClient.get('$_baseUrl/search',
          queryParameters: {
            'q': query,
            'format': 'json',
            'addressdetails': '1',
            'limit': limit.toString(),
            if (countryCode != null) 'countrycodes': countryCode,
            if (viewbox != null) 'viewbox': viewbox,
            'bounded': viewbox != null ? '1' : '0',
          },
          options: Options(
            headers: {
              'User-Agent': 'WasteManagementApp/1.0',
              'Accept-Language': 'vi,en',
            },
          ));
      final List data = response.data;
      return data.map((json) => SearchResult.fromJson(json)).toList();
    }catch(e){
      throw ApiErrorHandler.handle(e);
    }

  }

  // Tìm tên địa chỉ từ tọa độ (Reverse)
  Future<Map<String, dynamic>?> reverseGeocode(double lat, double lon) async {
    final response = await _dioClient.get(
      '$_baseUrl/reverse',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'format': 'json',
        'addressdetails': '1',
      },
    );
    return response.data as Map<String, dynamic>?;
  }
}
