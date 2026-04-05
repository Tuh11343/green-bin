import 'package:equatable/equatable.dart';

class CollectorStat extends Equatable {
  final int? id;
  final int userId;
  final int completedCollection;
  final DateTime? lastCollectionDate;

  const CollectorStat({
    this.id,
    required this.userId,
    this.completedCollection = 0,
    this.lastCollectionDate,
  });

  factory CollectorStat.fromJson(Map<String, dynamic> json) {
    return CollectorStat(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      completedCollection: json['completedCollection'] as int? ?? 0,
      lastCollectionDate: json['lastCollectionDate'] != null
          ? DateTime.parse(json['lastCollectionDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'completedCollection': completedCollection,
      'lastCollectionDate': lastCollectionDate?.toIso8601String(),
    };
  }

  CollectorStat copyWith({
    int? id,
    int? userId,
    int? completedCollection,
    DateTime? lastCollectionDate,
  }) {
    return CollectorStat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      completedCollection: completedCollection ?? this.completedCollection,
      lastCollectionDate: lastCollectionDate ?? this.lastCollectionDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    id,
    completedCollection,
    lastCollectionDate,
  ];
}