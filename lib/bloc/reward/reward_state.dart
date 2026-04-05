import 'package:equatable/equatable.dart';

import '../../models/reward.dart';

enum RewardStatus {
  initial,
  loading,
  success,
  failure,
  loadingMore,
  refreshing
}

enum RewardSort { newest, oldest, pointLowHigh, pointHighLow }

enum RewardFilterCriteria { all, inStock, outOfStock }

enum RedeemStatus { initial, loading, success, failure }

class RewardState extends Equatable {
  final List<Reward> rewards;
  final RewardStatus status;
  final int? nextCursor;
  final bool hasMore;

  final String searchQuery;
  final RewardSort sortBy;
  final RewardFilterCriteria filter;

  final String? errorMessage;

  final RedeemStatus redeemStatus;

  const RewardState({
    this.rewards = const [],
    this.status = RewardStatus.initial,
    this.nextCursor,
    this.hasMore = true,
    this.searchQuery = '',
    this.sortBy = RewardSort.newest,
    this.filter = RewardFilterCriteria.all,
    this.errorMessage,
    this.redeemStatus = RedeemStatus.initial,
  });

  RewardState copyWith({
    List<Reward>? rewards,
    RewardStatus? status,
    int? nextCursor,
    bool? hasMore,
    String? searchQuery,
    RewardSort? sortBy,
    RewardFilterCriteria? filter,
    String? errorMessage,
    RedeemStatus? redeemStatus,
  }) {
    return RewardState(
      rewards: rewards ?? this.rewards,
      status: status ?? this.status,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
      redeemStatus: redeemStatus ?? this.redeemStatus,
    );
  }

  @override
  List<Object?> get props => [
        rewards, status, nextCursor, hasMore,
        searchQuery, sortBy, filter, errorMessage,
        redeemStatus
      ];
}
