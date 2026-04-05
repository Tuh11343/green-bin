import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/bloc/point_transaction/redemption_history_event.dart';
import 'package:greenbin/bloc/point_transaction/redemption_history_state.dart';

import '../../repositories/app_event_bus.dart';
import '../../repositories/app_repository.dart';

class RedemptionHistoryBloc
    extends Bloc<RedemptionHistoryEvent, RedemptionHistoryState> {
  final AppRepository repository;
  late final StreamSubscription _sub;

  RedemptionHistoryBloc({required this.repository})
      : super(const RedemptionHistoryState()) {
    on<RedemptionHistoryFetched>(_onFetched, transformer: restartable());
    on<RedemptionHistoryLoadMore>(_onLoadMore, transformer: droppable());
    on<RedemptionHistorySortChanged>((event, emit) {
      emit(state.copyWith(sortBy: event.sortBy));
      add(RedemptionHistoryFetched());
    });

    //Lắng nghe sự kiện khi đổi quà thành coông
    _sub = AppEventBus().on<RedeemSuccessEvent>().listen((event) {
      add(RedemptionHistoryFetched());
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }

  Future<void> _onFetched(RedemptionHistoryFetched event,
      Emitter<RedemptionHistoryState> emit) async {
    try {
      emit(state
          .copyWith(status: RedemptionHistoryStatus.loading, transactions: []));

      final response =
          await repository.pointTransaction.getUserPointTransactions(
        limit: 10,
        cursor: null,
        sortBy: state.sortBy,
      );

      emit(state.copyWith(
        status: RedemptionHistoryStatus.success,
        transactions: response.data,
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: RedemptionHistoryStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMore(RedemptionHistoryLoadMore event,
      Emitter<RedemptionHistoryState> emit) async {
    if (!state.hasMore || state.status == RedemptionHistoryStatus.loadingMore) {
      return;
    }

    try {
      emit(state.copyWith(status: RedemptionHistoryStatus.loadingMore));

      final response =
          await repository.pointTransaction.getUserPointTransactions(
        limit: 10,
        cursor: state.nextCursor,
        sortBy: state.sortBy,
      );

      emit(state.copyWith(
        status: RedemptionHistoryStatus.success,
        transactions: [...state.transactions, ...response.data],
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(status: RedemptionHistoryStatus.failure));
    }
  }
}
