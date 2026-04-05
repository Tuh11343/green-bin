import 'package:equatable/equatable.dart';
import '../../models/point_transaction.dart';

enum RedemptionHistoryStatus { initial, loading, success, failure, loadingMore }

enum RedemptionHistorySort { newest, oldest }

class RedemptionHistoryState extends Equatable {
  final List<PointTransaction> transactions;
  final RedemptionHistoryStatus status;
  final int? nextCursor;
  final bool hasMore;
  final RedemptionHistorySort sortBy;
  final String? errorMessage;

  const RedemptionHistoryState({
    this.transactions = const [],
    this.status = RedemptionHistoryStatus.initial,
    this.nextCursor,
    this.hasMore = true,
    this.sortBy = RedemptionHistorySort.newest,
    this.errorMessage,
  });

  RedemptionHistoryState copyWith({
    List<PointTransaction>? transactions,
    RedemptionHistoryStatus? status,
    int? nextCursor,
    bool? hasMore,
    RedemptionHistorySort? sortBy,
    String? errorMessage,
  }) {
    return RedemptionHistoryState(
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      sortBy: sortBy ?? this.sortBy,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [transactions, status, nextCursor, hasMore, sortBy, errorMessage];
}