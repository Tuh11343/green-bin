import 'package:equatable/equatable.dart';
import 'package:greenbin/bloc/point_transaction/redemption_history_state.dart';

abstract class RedemptionHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RedemptionHistoryFetched extends RedemptionHistoryEvent {}

class RedemptionHistoryLoadMore extends RedemptionHistoryEvent {}

class RedemptionHistorySortChanged extends RedemptionHistoryEvent {
  final RedemptionHistorySort sortBy;
  RedemptionHistorySortChanged(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}