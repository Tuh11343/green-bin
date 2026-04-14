import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:greenbin/models/enums.dart';
import 'package:greenbin/models/report.dart';
import 'package:greenbin/services/http/dio_client.dart';
import 'package:greenbin/utils/api_parser.dart';

import '../../bloc/report/user_report_history/user_report_history_state.dart';
import '../../configs/api_endpoint.dart';
import '../../configs/api_error_handle.dart';
import '../../models/bin.dart';
import '../../models/response/paginated_response.dart';
import '../../models/response/report_detail_response.dart';

class ReportApi {
  final DioClient _dioClient = DioClient();

  Future<void> createNewReport({
    required Report report,
    required List<Uint8List> images,
  }) async {
    try {
      final Map<String, dynamic> dataMap = report.toFormDataMap();
      final formData = FormData();

      dataMap.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      for (int i = 0; i < images.length; i++) {
        final bytes = images[i];
        final String ext = _detectMimeType(bytes);

        formData.files.add(MapEntry(
          'images',
          MultipartFile.fromBytes(
            bytes,
            filename:
                'report_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: DioMediaType('image', ext),
          ),
        ));
      }

      await _dioClient.post(
        ApiEndpoints.createReport,
        data: formData,
      );

      return;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<Report> adminUpdateUserReport(
      {required Report report, Bin? bin}) async {
    try {
      final response =
          await _dioClient.post(ApiEndpoints.adminUpdateUserReport, data: {
        'report': report.toJson(),
        'bin': bin?.toJson(),
      });
      if (response.statusCode == 200 && response.data != null) {
        final reportData = response.data['data'];
        return Report.fromJson(reportData);
      } else {
        throw Exception('Create Report Failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<Report>> getUserReports({int? limit}) async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getUserRecentReports,
          queryParameters: {'limit': limit});

      return ApiParser.parseListData(
          response: response, fromJson: Report.fromJson, listKey: 'reports');
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  String _detectMimeType(Uint8List bytes) {
    if (bytes[0] == 0x89 && bytes[1] == 0x50) return 'png';
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'jpeg';
    return 'jpeg';
  }

  Future<PaginatedResponse<ReportDetailResponse>> getUserReportsPaginated({
    int? cursor,
    required int limit,
    required UserReportHistorySort sortBy,
    required ReportFilterCriteria filter,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getUserReportsPaginated,
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
          'limit': limit,
          'sortBy': sortBy.name,
          'filter':filter.name,
        },
      );

      return ApiParser.parsePaginatedData(
        response,
        listKey: 'reports',
        fromJson: ReportDetailResponse.fromJson,
      );
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
