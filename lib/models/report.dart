import 'package:equatable/equatable.dart';
import 'enums.dart';

class Report extends Equatable {
  final int? id;
  final int userId;
  final int? binId;
  final double latitude;
  final double longitude;
  final String addressName;
  final String description;
  final ReportStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Report({
    this.id,
    required this.userId,
    this.binId,
    required this.latitude,
    required this.longitude,
    required this.addressName,
    required this.description,
    this.status = ReportStatus.pending,
    this.createdAt,
    this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      binId: json['binId'] as int?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      addressName: json['addressName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: ReportStatusExtension.fromJson(json['status'] as String? ?? 'pending'),
      // Sửa: Kiểm tra null trước khi parse DateTime
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'binId': binId,
      'latitude': latitude,
      'longitude': longitude,
      'addressName': addressName,
      'description': description,
      'status': status.toJson(),
      // Fix lỗi: Thêm dấu '?' để chỉ gọi khi không null
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Report copyWith({
    int? id,
    int? userId,
    int? binId,
    double? latitude,
    double? longitude,
    String? addressName,
    String? description,
    ReportStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,

  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      binId: binId ?? this.binId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addressName: addressName ?? this.addressName,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,

    );
  }

  Map<String, dynamic> toFormDataMap() {
    return {
      'userId': userId.toString(),
      'binId': binId?.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'addressName': addressName,
      'description': description,
      'status': status.toString(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    binId,
    latitude,
    longitude,
    addressName,
    description,
    status,
    createdAt,
    updatedAt,

  ];
}