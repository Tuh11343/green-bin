import 'package:latlong2/latlong.dart';

class SearchResult {
  final String displayName;
  final LatLng position;
  final String type;
  final Map<String, dynamic> address;

  SearchResult({
    required this.displayName,
    required this.position,
    required this.type,
    required this.address,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      displayName: json['display_name'] ?? '',
      position: LatLng(
        double.parse(json['lat']),
        double.parse(json['lon']),
      ),
      type: json['type'] ?? '',
      address: json['address'] ?? {},
    );
  }

  String get shortName {
    if (address.containsKey('road')) {
      return address['road'];
    } else if (address.containsKey('suburb')) {
      return address['suburb'];
    } else if (address.containsKey('city')) {
      return address['city'];
    }
    return displayName.split(',').first;
  }
}