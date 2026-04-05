import 'package:greenbin/models/point_transaction.dart';
import 'package:greenbin/models/response/paginated_response.dart';

import '../../services/api/app_api.dart';
import '../bloc/point_transaction/redemption_history_state.dart';
import '../configs/exception.dart';

abstract class IPointTransactionRepository {
  Future<PaginatedResponse> getUserPointTransactions({
    int? cursor,
    required int limit,
    required RedemptionHistorySort sortBy,
  });
}

class PointTransactionRepository implements IPointTransactionRepository {
  final _api = AppApi().pointTransaction;

  @override
  Future<PaginatedResponse<PointTransaction>> getUserPointTransactions({
    int? cursor,
    required int limit,
    required RedemptionHistorySort sortBy,
  }) async {
    try {
      return await _api.getUserPointTransaction(
        limit: limit,
        cursor: cursor,
        sortBy: sortBy,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }
}
