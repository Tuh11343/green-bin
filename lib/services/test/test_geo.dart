// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
//
// /// Model cho kết quả tìm kiếm địa điểm
// class SearchResult {
//   final String displayName;
//   final LatLng position;
//   final String type;
//   final Map<String, dynamic> address;
//
//   SearchResult({
//     required this.displayName,
//     required this.position,
//     required this.type,
//     required this.address,
//   });
//
//   factory SearchResult.fromJson(Map<String, dynamic> json) {
//     return SearchResult(
//       displayName: json['display_name'] ?? '',
//       position: LatLng(
//         double.parse(json['lat']),
//         double.parse(json['lon']),
//       ),
//       type: json['type'] ?? '',
//       address: json['address'] ?? {},
//     );
//   }
//
//   String get shortName {
//     if (address.containsKey('road')) {
//       return address['road'];
//     } else if (address.containsKey('suburb')) {
//       return address['suburb'];
//     } else if (address.containsKey('city')) {
//       return address['city'];
//     }
//     return displayName.split(',').first;
//   }
// }
//
// /// Service để thực hiện geocoding và reverse geocoding
// class GeocodingService {
//   static const String _baseUrl = 'https://nominatim.openstreetmap.org';
//   static const String _userAgent = 'WasteManagementApp/1.0';
//
//   /// Tìm kiếm địa điểm theo query string
//   ///
//   /// [query]: Chuỗi tìm kiếm (tên đường, địa chỉ, địa danh)
//   /// [limit]: Số lượng kết quả tối đa (mặc định: 5)
//   /// [countryCode]: Mã quốc gia để giới hạn kết quả (vd: 'vn' cho Việt Nam)
//   /// [viewbox]: Giới hạn kết quả trong một vùng (minLon,minLat,maxLon,maxLat)
//   static Future<List<SearchResult>> searchLocation({
//     required String query,
//     int limit = 5,
//     String? countryCode,
//     String? viewbox,
//   }) async {
//     if (query.trim().isEmpty) {
//       return [];
//     }
//
//     try {
//       final uri = Uri.parse('$_baseUrl/search').replace(
//         queryParameters: {
//           'q': query,
//           'format': 'json',
//           'addressdetails': '1',
//           'limit': limit.toString(),
//           if (countryCode != null) 'countrycodes': countryCode,
//           if (viewbox != null) 'viewbox': viewbox,
//           'bounded': viewbox != null ? '1' : '0',
//         },
//       );
//
//       final response = await http.get(
//         uri,
//         headers: {
//           'User-Agent': _userAgent,
//           'Accept-Language': 'vi,en',
//         },
//       ).timeout(const Duration(seconds: 10));
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.map((json) => SearchResult.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to search location: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error searching location: $e');
//       return [];
//     }
//   }
//
//   /// Reverse geocoding: Tìm địa chỉ từ tọa độ
//   ///
//   /// [position]: Tọa độ cần tìm địa chỉ
//   /// [zoom]: Mức độ chi tiết (1-18, càng cao càng chi tiết)
//   static Future<SearchResult?> reverseGeocode({
//     required LatLng position,
//     int zoom = 18,
//   }) async {
//     try {
//       final uri = Uri.parse('$_baseUrl/reverse').replace(
//         queryParameters: {
//           'lat': position.latitude.toString(),
//           'lon': position.longitude.toString(),
//           'format': 'json',
//           'addressdetails': '1',
//           'zoom': zoom.toString(),
//         },
//       );
//
//       final response = await http.get(
//         uri,
//         headers: {
//           'User-Agent': _userAgent,
//           'Accept-Language': 'vi,en',
//         },
//       ).timeout(const Duration(seconds: 10));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return SearchResult.fromJson(data);
//       } else {
//         throw Exception('Failed to reverse geocode: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error reverse geocoding: $e');
//       return null;
//     }
//   }
//
//   /// Tìm kiếm địa điểm gần với một vị trí cụ thể
//   ///
//   /// [center]: Tọa độ trung tâm
//   /// [radiusKm]: Bán kính tìm kiếm (km)
//   /// [query]: Chuỗi tìm kiếm
//   static Future<List<SearchResult>> searchNearby({
//     required LatLng center,
//     required double radiusKm,
//     required String query,
//     int limit = 10,
//   }) async {
//     // Tính viewbox dựa trên bán kính
//     // 1 độ latitude ~ 111km, 1 độ longitude ~ 111km * cos(latitude)
//     final latOffset = radiusKm / 111.0;
//     final lonOffset = radiusKm / (111.0 * (center.latitude * 3.14159 / 180.0).abs());
//
//     final viewbox = [
//       center.longitude - lonOffset, // minLon
//       center.latitude - latOffset, // minLat
//       center.longitude + lonOffset, // maxLon
//       center.latitude + latOffset, // maxLat
//     ].join(',');
//
//     return searchLocation(
//       query: query,
//       limit: limit,
//       viewbox: viewbox,
//     );
//   }
// }