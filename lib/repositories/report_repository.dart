import 'dart:typed_data';

import 'package:greenbin/models/enums.dart';
import 'package:greenbin/models/response/paginated_response.dart';
import 'package:greenbin/models/response/report_detail_response.dart';
import 'package:greenbin/repositories/app_event_bus.dart';
import 'package:greenbin/services/app_secure_storage.dart';

import '../../models/report.dart';
import '../../models/bin.dart';
import '../../services/api/app_api.dart';
import '../bloc/report/user_report_history/user_report_history_state.dart';
import '../configs/exception.dart';
import '../models/user.dart';

abstract class IReportRepository {
  Future<List<Report>> getUserReports({int? limit});

  Future<void> createNewReport(
      {required Report report, required List<Uint8List> images});

  Future<PaginatedResponse<ReportDetailResponse>> getUserReportsPaginated(
      {required int limit,
      required UserReportHistorySort sortBy,
      int? cursor,
      ReportStatus? reportStatus});

  Future<Report> updateReportStatus({required Report report, Bin? bin});
}

class ReportRepository implements IReportRepository {
  final _api = AppApi().report;

  @override
  Future<List<Report>> getUserReports({int? limit}) async {
    try {
      User? user = await AppStorage.getUser();
      if (user == null) {
        throw UnknownException('Không có thông tin người dùng');
      }

      return await _api.getUserReports(limit: limit);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }

  @override
  Future<void> createNewReport(
      {required Report report, required List<Uint8List> images}) async {
    try {
      await _api.createNewReport(report: report, images: images);

      AppEventBus().emit(CreateNewReportEvent());

      return;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }

  @override
  Future<Report> updateReportStatus({required Report report, Bin? bin}) async {
    try {
      return await _api.adminUpdateUserReport(report: report, bin: bin);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }

  @override
  Future<PaginatedResponse<ReportDetailResponse>> getUserReportsPaginated(
      {required int limit,
        required UserReportHistorySort sortBy,
        int? cursor,
        ReportStatus? reportStatus}) async {
    try {
      final result = await _api.getUserReportsPaginated(
          limit: limit,
          sortBy: sortBy,
          cursor: cursor,
          reportStatus: reportStatus);
      return result;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }
}
