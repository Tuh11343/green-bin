import 'package:equatable/equatable.dart';
import 'package:greenbin/models/enums.dart';

class TaskPhoto extends Equatable {
  final int? id;
  final int collectionTaskId;
  final String imageUrl;
  final String publicImageUrl;
  final TaskPhotoType type;

  const TaskPhoto(
      {this.id,
      required this.collectionTaskId,
      required this.imageUrl,
      required this.publicImageUrl,
      required this.type});

  factory TaskPhoto.fromJson(Map<String, dynamic> json) {
    return TaskPhoto(
        id: json['id'],
        collectionTaskId: json['collectionTaskId'],
        imageUrl: json['imageUrl'],
        publicImageUrl: json['publicImageUrl'],
        type: TaskPhotoTypeExtension.fromJson(json['type']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collectionTaskId': collectionTaskId,
      'imageUrl': imageUrl,
      'publicImageUrl': publicImageUrl,
      'type': type
    };
  }

  @override
  List<Object?> get props =>
      [id, collectionTaskId, imageUrl, publicImageUrl, type];
}
