import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/exception.dart';
import '../../models/report.dart';
import '../../repositories/app_repository.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final AppRepository _repository;

  ReportCubit(this._repository) : super(const ReportState());

  Future<void> getUserRecentReports({int limit = 5}) async {
    emit(state.copyWith(
      status: ReportStatusState.loading,
      action: ReportAction.fetchRecent,
    ));
    try {
      final data = await _repository.report.getUserReports(limit: limit);
      emit(state.copyWith(
        status: ReportStatusState.success,
        action: ReportAction.fetchRecent,
        reports: data,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: ReportStatusState.failure,
        action: ReportAction.fetchRecent,
        message: e.message,
      ));
    }
  }

  Future<void> createNewReport(
      {required Report report, required List<Uint8List> images}) async {
    emit(state.copyWith(
      status: ReportStatusState.loading,
      action: ReportAction.create,
    ));
    try {
      await _repository.report.createNewReport(report: report, images: images);
      emit(state.copyWith(
        status: ReportStatusState.success,
        action: ReportAction.create,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: ReportStatusState.failure,
        action: ReportAction.create,
        message: e.message,
      ));
    }
  }
}
