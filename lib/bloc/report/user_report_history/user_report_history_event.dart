import 'package:equatable/equatable.dart';

import '../../../models/enums.dart';
import 'user_report_history_state.dart';

sealed class UserReportHistoryEvent extends Equatable {
  const UserReportHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchReportsEvent extends UserReportHistoryEvent {
  const FetchReportsEvent();
}

class LoadMoreReportsEvent extends UserReportHistoryEvent {
  const LoadMoreReportsEvent();
}

class ChangeSortByEvent extends UserReportHistoryEvent {
  final UserReportHistorySort sortBy;

  const ChangeSortByEvent(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

class ChangeFilterCriteriaEvent extends UserReportHistoryEvent {
  final ReportFilterCriteria filterCriteria;

  const ChangeFilterCriteriaEvent(this.filterCriteria);

  @override
  List<Object?> get props => [filterCriteria];
}