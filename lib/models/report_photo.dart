import 'package:equatable/equatable.dart';
import 'enums.dart';

class ReportPhoto extends Equatable {
  final int? id;
  final int reportId;
  final String imageUrl;
  final String publicImageUrl;

  const ReportPhoto({
    this.id,
    required this.reportId,
    required this.imageUrl,
    required this.publicImageUrl,
  });

  factory ReportPhoto.fromJson(Map<String, dynamic> json) {
    return ReportPhoto(
      id: json['id'] as int?,
      reportId: json['reportId'] as int,
      imageUrl: json['imageURL'] as String? ?? '',
      publicImageUrl: json['publicImageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportId': reportId,
      'imageURL': imageUrl,
      'publicImageUrl': publicImageUrl,
    };
  }

  @override
  List<Object?> get props => [id, reportId, imageUrl, publicImageUrl];
}
