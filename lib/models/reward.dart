import 'package:equatable/equatable.dart';

class Reward extends Equatable {
  final int? id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? publicImageUrl;
  final int stockQuantity;
  final int point;

  const Reward(
      {this.id,
      required this.name,
      required this.description,
      required this.stockQuantity,
      required this.point,
        this.publicImageUrl,
      this.imageUrl});

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      stockQuantity: json['stockQuantity'] as int,
      point: json['point'] as int,
      imageUrl: json['imageUrl'] as String?,
      publicImageUrl: json['publicImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'stockQuantity': stockQuantity,
      'point': point,
      'imageUrl': imageUrl,
      'publicImageUrl':publicImageUrl,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, description, stockQuantity, point, imageUrl,publicImageUrl];
}
