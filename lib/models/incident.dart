import 'package:equatable/equatable.dart';
import 'enums.dart';

class Incident extends Equatable {
  final int? id;
  final int userId;
  final double latitude;
  final double longitude;
  final String description;
  final IncidentType type;
  final String? imageUrl;
  final String? publicImageUrl;
  final IncidentStatus status;
  final Priority priority;
  final int? binId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Incident({
    this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.type = IncidentType.Other,
    this.imageUrl,
    this.publicImageUrl,
    this.status = IncidentStatus.OPEN,
    this.priority = Priority.Medium,
    this.binId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longtitude'] as num).toDouble(),
      description: json['description'] as String,
      type: IncidentTypeExtension.fromJson(json['type'] as String? ?? 'Other'),
      imageUrl: json['imageURL'] as String?,
      publicImageUrl: json['publicImageUrl'] as String?,
      status: IncidentStatusExtension.fromJson(json['status'] as String),
      priority: PriorityExtension.fromJson(json['priority'] as String? ?? 'Medium'),
      binId: json['binId'] as int?,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'latitude': latitude,
      'longtitude': longitude,
      'description': description,
      'type': type.toJson(),
      'imageURL': imageUrl,
      'publicImageUrl':publicImageUrl,
      'status': status.toJson(),
      'priority': priority.toJson(),
      'binId': binId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    latitude,
    longitude,
    description,
    type,
    imageUrl,
    publicImageUrl,
    status,
    priority,
    binId,
    createdAt,
    updatedAt,
  ];
}