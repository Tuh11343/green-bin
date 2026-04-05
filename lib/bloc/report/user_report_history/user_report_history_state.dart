import 'package:equatable/equatable.dart';
import 'package:greenbin/models/response/report_detail_response.dart';

import '../../../models/enums.dart';

enum UserReportHistorySort { newest, oldest }

enum UserReportHistoryStatus { initial, loading, loadingMore, success, failure }

class UserReportHistoryState extends Equatable {
  final List<ReportDetailResponse> reportResponses;
  final UserReportHistoryStatus status;
  final int? nextCursor;
  final bool hasMore;
  final UserReportHistorySort sortBy;
  final ReportStatus? filterCriteria;
  final String? errorMessage;

  const UserReportHistoryState({
    this.reportResponses = const [],
    this.status = UserReportHistoryStatus.initial,
    this.nextCursor,
    this.hasMore = true,
    this.sortBy = UserReportHistorySort.newest,
    this.filterCriteria,
    this.errorMessage,
  });

  UserReportHistoryState copyWith({
    List<ReportDetailResponse>? reportResponses,
    UserReportHistoryStatus? status,
    int? nextCursor,
    bool? hasMore,
    UserReportHistorySort? sortBy,
    String? errorMessage,
    ReportStatus? filterCriteria,
    bool clearFilterCriteria = false,
  }) {
    return UserReportHistoryState(
      reportResponses: reportResponses ?? this.reportResponses,
      status: status ?? this.status,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      sortBy: sortBy ?? this.sortBy,
      filterCriteria: clearFilterCriteria ? null : (filterCriteria ?? this.filterCriteria),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    reportResponses,
    status,
    nextCursor,
    hasMore,
    filterCriteria,
    sortBy,
    errorMessage,
  ];
}