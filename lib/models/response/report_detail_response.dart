import 'package:equatable/equatable.dart';
import '../bin.dart';
import '../report.dart';
import '../report_photo.dart';

class ReportDetailResponse extends Equatable {
  final Report report;
  final Bin? bin;
  final List<ReportPhoto> reportPhotos;

  const ReportDetailResponse({
    required this.report,
    this.bin,
    this.reportPhotos = const [],
  });

  factory ReportDetailResponse.fromJson(Map<String, dynamic> json) {
    final List<ReportPhoto> photos = json['reportPhotos'] != null
        ? (json['reportPhotos'] as List<dynamic>)
            .map((photo) => ReportPhoto.fromJson(photo as Map<String, dynamic>))
            .toList()
        : [];

    return ReportDetailResponse(
      report: Report.fromJson(json),
      bin: json['bin'] != null
          ? Bin.fromJson(json['bin'] as Map<String, dynamic>)
          : null,
      reportPhotos: photos,
    );
  }

  ReportDetailResponse copyWith({
    Report? report,
    Bin? bin,
    List<ReportPhoto>? reportPhotos,
  }) {
    return ReportDetailResponse(
      report: report ?? this.report,
      bin: bin ?? this.bin,
      reportPhotos: reportPhotos ?? this.reportPhotos,
    );
  }

  @override
  List<Object?> get props => [report, bin, reportPhotos];
}

extension ReportDetailResponseListX on List<ReportDetailResponse> {
  List<Report> toReportList() {
    return map((e) => e.report).toList();
  }
}