import 'package:latlong2/latlong.dart';

import '../models/search_result_map/search_result.dart';
import '../services/api/geocoding_api.dart';

class GeocodingRepository {
  final GeocodingApi _geocodingApi = GeocodingApi();

  // Hàm Search
  Future<List<SearchResult>> searchLocation({
    required String query,
    int limit = 5,
    String countryCode = 'vn',
    String viewbox = '106.3,10.3,107.0,11.2',
  }) async {
    try {
      final rawData = await _geocodingApi.searchLocation(
        query: query,
        limit: limit,
        countryCode: countryCode,
        viewbox: viewbox,
      );
      return rawData.map((json) => SearchResult.fromJson(json)).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Hàm Reverse
  Future<SearchResult?> reverseGeocode(LatLng position) async {
    try {
      final rawData = await _geocodingApi.reverseGeocode(
        position.latitude,
        position.longitude,
      );
      if (rawData != null) {
        return SearchResult.fromJson(rawData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}