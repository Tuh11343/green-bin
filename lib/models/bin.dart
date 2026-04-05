import 'package:equatable/equatable.dart';
import 'enums.dart';

class Bin extends Equatable {
  final int? id;
  final double latitude;
  final double longitude;
  final int reportCount;
  final FillLevel fillLevel;
  final BinType type;
  final String? qrCode;
  final DateTime? lastEmptiedAt;
  final String? addressName;


  const Bin({
    this.id,
    required this.latitude,
    required this.longitude,
    this.reportCount = 0,
    this.fillLevel = FillLevel.low,
    required this.type,
    this.qrCode,
    this.lastEmptiedAt,
    this.addressName
  });

  factory Bin.fromJson(Map<String, dynamic> json) {
    return Bin(
      id: json['id'] as int?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      reportCount: json['reportCount'] as int? ?? 0,
      fillLevel: FillLevelExtension.fromJson(json['fillLevel'] as String),
      type: BinTypeExtension.fromJson(json['type'] as String),
      qrCode: json['qrCode'] as String?,
      lastEmptiedAt: json['lastEmptiedAt'] != null
          ? DateTime.parse(json['lastEmptiedAt'])
          : null,
      addressName: json['addressName']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'reportCount': reportCount,
      'fillLevel': fillLevel.toJson(),
      'type': type.toJson(),
      'qrCode': qrCode,
      'lastEmptiedAt': lastEmptiedAt?.toIso8601String(),
      'addressName': addressName
    };
  }

  Bin copyWith({
    int? id,
    double? latitude,
    double? longitude,
    int? reportCount,
    FillLevel? fillLevel,
    BinType? type,
    String? qrCode,
    DateTime? lastEmptiedAt,
    String? addressName
  }) {
    return Bin(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reportCount: reportCount ?? this.reportCount,
      fillLevel: fillLevel ?? this.fillLevel,
      type: type ?? this.type,
      qrCode: qrCode ?? this.qrCode,
      lastEmptiedAt: lastEmptiedAt ?? this.lastEmptiedAt,
      addressName: addressName ?? this.addressName
    );
  }

  @override
  List<Object?> get props => [
    id,
    latitude,
    longitude,
    reportCount,
    fillLevel,
    type,
    qrCode,
    lastEmptiedAt,
    addressName
  ];
}