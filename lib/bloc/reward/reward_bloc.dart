import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/bloc/reward/reward_event.dart';
import 'package:greenbin/bloc/reward/reward_state.dart';
import 'package:greenbin/repositories/app_repository.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/reward.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final AppRepository _repo;

  static const int _pageSize = 10;

  RewardBloc({required AppRepository repository})
      : _repo = repository,
        super(const RewardState()) {
    on<RewardFetched>(_onRewardFetched, transformer: restartable());
    on<RewardLoadMoreFetched>(_onRewardLoadMoreFetched,
        transformer: droppable());
    on<RewardFilterChanged>(_onRewardFilterChanged);
    on<RewardSortChanged>(_onRewardSortChanged);
    on<RewardSearchChanged>(_onRewardSearchChanged,
        transformer: debounce(const Duration(milliseconds: 700)));
    on<RewardResetAll>(_onRewardResetAll);
    on<RedeemReward>(_onRedeemReward);
  }

  Future<void> _onRewardFetched(
    RewardFetched event,
    Emitter<RewardState> emit,
  ) async {
    emit(state.copyWith(status: RewardStatus.loading));

    try {
      final response = await _repo.reward.getAllRewards(
        limit: _pageSize,
        cursor: null,
        search: state.searchQuery,
        sortBy: state.sortBy,
        filter: state.filter,
      );

      emit(state.copyWith(
        status: RewardStatus.success,
        rewards: response.data as List<Reward>,
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RewardStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRewardLoadMoreFetched(
    RewardLoadMoreFetched event,
    Emitter<RewardState> emit,
  ) async {
    if (!state.hasMore || state.status == RewardStatus.loadingMore) return;

    emit(state.copyWith(status: RewardStatus.loadingMore));

    try {
      final response = await _repo.reward.getAllRewards(
        limit: _pageSize,
        cursor: state.nextCursor,
        search: state.searchQuery,
        sortBy: state.sortBy,
        filter: state.filter,
      );

      emit(state.copyWith(
        status: RewardStatus.success,
        rewards: [...state.rewards, ...response.data],
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.failure));
    }
  }

  void _onRewardFilterChanged(
    RewardFilterChanged event,
    Emitter<RewardState> emit,
  ) {
    try {
      emit(state.copyWith(filter: event.filter, status: RewardStatus.loading));
      add(RewardFetched());
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.failure));
    }
  }

  void _onRewardSortChanged(
    RewardSortChanged event,
    Emitter<RewardState> emit,
  ) {
    try {
      emit(state.copyWith(sortBy: event.sortBy, status: RewardStatus.loading));
      add(RewardFetched());
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.failure));
    }
  }

  Future<void> _onRewardSearchChanged(
    RewardSearchChanged event,
    Emitter<RewardState> emit,
  ) async {
    emit(state.copyWith(
      searchQuery: event.query,
      status: RewardStatus.loading,
      rewards: [],
    ));

    try {
      final response = await _repo.reward.getAllRewards(
        limit: _pageSize,
        cursor: null,
        search: event.query,
        sortBy: state.sortBy,
        filter: state.filter,
      );

      emit(state.copyWith(
        status: RewardStatus.success,
        rewards: response.data as List<Reward>,
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.failure));
    }
  }

  void _onRewardResetAll(
    RewardResetAll event,
    Emitter<RewardState> emit,
  ) {
    emit(state.copyWith(
      sortBy: RewardSort.newest,
      filter: RewardFilterCriteria.all,
      searchQuery: '',
      status: RewardStatus.loading,
    ));

    add(RewardFetched());
  }

  Future<void> _onRedeemReward(
    RedeemReward event,
    Emitter<RewardState> emit,
  ) async {
    emit(state.copyWith(redeemStatus: RedeemStatus.loading));

    try {
      await _repo.reward.redeemReward(
        rewardId: event.rewardId,
        point: event.point,
      );

      emit(state.copyWith(redeemStatus: RedeemStatus.success));
    } catch (e) {
      emit(state.copyWith(
        redeemStatus: RedeemStatus.failure,
        errorMessage: 'Đổi quà thất bại, vui lòng thử lại',
      ));
    }
  }
}
