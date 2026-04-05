import 'package:equatable/equatable.dart';
import 'package:greenbin/bloc/reward/reward_state.dart';

abstract class RewardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RewardFetched extends RewardEvent {}

class RewardLoadMoreFetched extends RewardEvent {}

class RewardSearchChanged extends RewardEvent {
  final String query;
  RewardSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class RewardSortChanged extends RewardEvent {
  final RewardSort sortBy;
  RewardSortChanged(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

class RewardFilterChanged extends RewardEvent {
  final RewardFilterCriteria filter;
  RewardFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}


class RedeemReward extends RewardEvent{
  final int rewardId;
  final int point;

  RedeemReward(this.rewardId,this.point);

  @override
  List<Object?> get props => [rewardId,point];

}

class RewardResetAll extends RewardEvent {}