
enum CollectionTaskStatus { pending, inProgress, completed, cancelled }

extension CollectionTaskStatusExtension on CollectionTaskStatus{
  String toJson() => name;

  static CollectionTaskStatus fromJson(String json) {
    return CollectionTaskStatus.values.firstWhere(
          (role) => role.name == json,
      orElse: () => CollectionTaskStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case CollectionTaskStatus.pending:
        return 'Đang chờ xử lý';
      case CollectionTaskStatus.inProgress:
        return 'Đang chờ xử lý';
      case CollectionTaskStatus.completed:
        return 'Đã hoàn thành';
      case CollectionTaskStatus.cancelled:
        return 'Đã hủy';
    }
  }
}

enum UserRole { resident, collector, admin }

extension UserRoleExtension on UserRole {
  String toJson() => name;

  static UserRole fromJson(String json) {
    return UserRole.values.firstWhere(
          (role) => role.name == json,
      orElse: () => UserRole.resident,
    );
  }

  String get displayName {
    switch (this) {
      case UserRole.resident:
        return 'Cư dân';
      case UserRole.collector:
        return 'Nhân viên thu gom';
      case UserRole.admin:
        return 'Quản trị viên';
    }
  }
}

enum NotificationType {
  ReportCreated,
  ReportUpdate,
  SystemAlert,
  BinFullAlert,
  NewAssignment,
}

extension NotificationTypeExtension on NotificationType {
  String toJson() => name;

  static NotificationType fromJson(String json) {
    return NotificationType.values.firstWhere(
          (e) => e.name == json,
      orElse: () => NotificationType.ReportUpdate,
    );
  }
}

enum FillLevel { low, medium, high }

extension FillLevelExtension on FillLevel {
  String toJson() => name;

  static FillLevel fromJson(String json) {
    return FillLevel.values.firstWhere(
          (e) => e.name == json,
      orElse: () => FillLevel.low,
    );
  }
}

enum BinType { organic, recyclable, non_recyclable }

extension BinTypeExtension on BinType {
  String toJson() => name;

  static BinType fromJson(String json) {
    return BinType.values.firstWhere(
          (e) => e.name == json,
      orElse: () => BinType.organic,
    );
  }
}

enum IncidentType { Other }

extension IncidentTypeExtension on IncidentType {
  String toJson() => name;

  static IncidentType fromJson(String json) {
    return IncidentType.values.firstWhere(
          (e) => e.name == json,
      orElse: () => IncidentType.Other,
    );
  }
}

enum IncidentStatus { OPEN, IN_Progress, Resolved }

extension IncidentStatusExtension on IncidentStatus {
  String toJson() => name;

  static IncidentStatus fromJson(String json) {
    return IncidentStatus.values.firstWhere(
          (e) => e.name == json,
      orElse: () => IncidentStatus.OPEN,
    );
  }
}

enum Priority { Low, Medium, High }

extension PriorityExtension on Priority {
  String toJson() => name;

  static Priority fromJson(String json) {
    return Priority.values.firstWhere(
          (e) => e.name == json,
      orElse: () => Priority.Medium,
    );
  }
}

enum ReportStatus { pending, processing, completed, cancelled }

extension ReportStatusExtension on ReportStatus {
  String toJson() => name;

  static ReportStatus fromJson(String json) {
    return ReportStatus.values.firstWhere(
          (e) => e.name == json,
      orElse: () => ReportStatus.pending,
    );
  }
}

enum TaskPhotoType { before,after }

extension TaskPhotoTypeExtension on TaskPhotoType {
  String toJson() => name;

  static TaskPhotoType fromJson(String json) {
    return TaskPhotoType.values.firstWhere(
          (e) => e.name == json,
      orElse: () => TaskPhotoType.before,
    );
  }
}