import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/app_repository.dart';
import 'user_report_history_event.dart';
import 'user_report_history_state.dart';

class UserReportHistoryBloc
    extends Bloc<UserReportHistoryEvent, UserReportHistoryState> {
  final AppRepository _repository;

  static const int _pageSize = 10;

  UserReportHistoryBloc({required AppRepository repository})
      : _repository = repository,
        super(const UserReportHistoryState()) {
    on<FetchReportsEvent>(_onFetchReports);
    on<LoadMoreReportsEvent>(_onLoadMoreReports);
    on<ChangeSortByEvent>(_onChangeSortBy);
    on<ChangeFilterCriteriaEvent>(_onChangeFilterCriteria);
  }


  Future<void> _onFetchReports(
    FetchReportsEvent event,
    Emitter<UserReportHistoryState> emit,
  ) async {
    emit(state.copyWith(
      status: UserReportHistoryStatus.loading,
      reportResponses: [],
      nextCursor: null,
      hasMore: true,
    ));

    try {
      final response = await _repository.report.getUserReportsPaginated(
        limit: _pageSize,
        sortBy: state.sortBy,
        filter: state.filterCriteria,
        cursor: null,
      );

      emit(state.copyWith(
        status: UserReportHistoryStatus.success,
        reportResponses: response.data,
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: UserReportHistoryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreReports(
    LoadMoreReportsEvent event,
    Emitter<UserReportHistoryState> emit,
  ) async {
    final bool isAlreadyLoadingMore =
        state.status == UserReportHistoryStatus.loadingMore;

    if (isAlreadyLoadingMore || !state.hasMore) return;

    emit(state.copyWith(status: UserReportHistoryStatus.loadingMore));

    try {
      final response = await _repository.report.getUserReportsPaginated(
        limit: _pageSize,
        sortBy: state.sortBy,
        filter: state.filterCriteria,
        cursor: state.nextCursor,
      );

      emit(state.copyWith(
        status: UserReportHistoryStatus.success,
        reportResponses: [...state.reportResponses, ...response.data],
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: UserReportHistoryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onChangeSortBy(
    ChangeSortByEvent event,
    Emitter<UserReportHistoryState> emit,
  ) async {
    if (state.sortBy == event.sortBy) return;

    emit(state.copyWith(
      sortBy: event.sortBy,
      filterCriteria: state.filterCriteria,
      reportResponses: [],
      nextCursor: null,
      hasMore: true,
      status: UserReportHistoryStatus.loading,
    ));

    try {
      final response = await _repository.report.getUserReportsPaginated(
        limit: _pageSize,
        sortBy: event.sortBy,
        filter: state.filterCriteria,
        cursor: null,
      );

      emit(state.copyWith(
        status: UserReportHistoryStatus.success,
        reportResponses: response.data,
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: UserReportHistoryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }


  Future<void> _onChangeFilterCriteria(
    ChangeFilterCriteriaEvent event,
    Emitter<UserReportHistoryState> emit,
  ) async {

    emit(state.copyWith(
      filterCriteria: event.filterCriteria,
      reportResponses: [],
      nextCursor: null,
      hasMore: true,
      status: UserReportHistoryStatus.loading,
    ));

    try {
      final response = await _repository.report.getUserReportsPaginated(
        limit: _pageSize,
        sortBy: state.sortBy,
        filter: event.filterCriteria,
        cursor: null,
      );

      emit(state.copyWith(
        status: UserReportHistoryStatus.success,
        reportResponses: response.data,
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: UserReportHistoryStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
