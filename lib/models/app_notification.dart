import 'package:equatable/equatable.dart';
import 'enums.dart';

class AppNotification extends Equatable {
  final int? id;
  final int userId;
  final String title;
  final String description;
  final NotificationType type;
  final int? reportId;
  final int? binId;
  final bool isRead;
  final DateTime? createdAt;

  const AppNotification({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    this.reportId,
    this.binId,
    this.isRead = false,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      type: NotificationTypeExtension.fromJson(json['type'] as String),
      reportId: json['reportId'] as int?,
      binId: json['binId'] as int?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': id,
      'title': title,
      'description': description,
      'type': type.toJson(),
      'reportId': reportId,
      'binId': binId,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  AppNotification copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    NotificationType? type,
    int? reportId,
    int? binId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: id ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      reportId: reportId ?? this.reportId,
      binId: binId ?? this.binId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    type,
    reportId,
    binId,
    isRead,
    createdAt,
  ];
}