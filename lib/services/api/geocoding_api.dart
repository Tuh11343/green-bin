import 'package:dio/dio.dart';

import '../http/dio_client.dart';

class GeocodingApi {
  final DioClient _dioClient = DioClient();
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  // Tìm kiếm theo tên
  Future<List<dynamic>> searchLocation({
    required String query,
    int limit = 5,
    String? countryCode,
    String? viewbox,
  }) async {
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
            'User-Agent': 'WasteManagementApp/1.0', // Đặt tên app của bạn
            'Accept-Language': 'vi,en',
          },
        ));
    return response.data as List<dynamic>;
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
