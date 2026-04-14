import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../configs/exception.dart';
import '../models/search_result_map/search_result.dart';
import '../services/api/google_map_api.dart';

class GoogleMapRepository {
  final GoogleMapApi _geocodingApi;

  GoogleMapRepository({required GoogleMapApi api})
      : _geocodingApi = api;

  // Hàm Search
  Future<List<SearchResult>> searchLocation({
    required String query,
    int limit = 5,
    String countryCode = 'vn',
    String viewbox = '106.3,10.3,107.0,11.2',
  }) async {
    try {
      List<SearchResult> resultList= await _geocodingApi.searchLocation(
        query: query,
        limit: limit,
        countryCode: countryCode,
        viewbox: viewbox,
      );
      return resultList;
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      throw UnknownException("Lỗi search location từ repo");
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