import 'package:equatable/equatable.dart';
import 'package:greenbin/models/enums.dart';

class CollectionTask extends Equatable {
  final int? id;
  final int binId;
  final int userId;
  final CollectionTaskStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final String? notes;

  const CollectionTask(
      {this.id,
      required this.binId,
      required this.userId,
      required this.status,
      this.startedAt,
      this.completedAt,
      this.createdAt,
      this.notes});

  factory CollectionTask.fromJson(Map<String, dynamic> json) {
    return CollectionTask(
        id: json['id'],
        binId: json['binId'],
        userId: json['userId'],
        status: CollectionTaskStatusExtension.fromJson(
          json['collectionTaskStatus'],
        ),
      startedAt: DateTime.parse(json['startedAt']),
      completedAt: DateTime.parse(json['completedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      notes: json['notes']

    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'binId':binId,
      'userId':userId,
      'status':status,
      'startedAt':startedAt?.toIso8601String(),
      'completedAt':completedAt?.toIso8601String(),
      'createdAt':createdAt?.toIso8601String(),
      'notes':notes
    };
  }

  @override
  List<Object?> get props =>
      [id, binId, userId, status, startedAt, completedAt, createdAt, notes];
}
