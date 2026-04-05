import 'package:greenbin/bloc/point_transaction/redemption_history_state.dart';
import 'package:greenbin/configs/api_endpoint.dart';
import 'package:greenbin/models/point_transaction.dart';
import 'package:greenbin/models/response/paginated_response.dart';
import 'package:greenbin/services/http/dio_client.dart';
import 'package:greenbin/utils/api_parser.dart';

import '../../configs/api_error_handle.dart';

class PointTransactionApi {
  final DioClient _dioClient = DioClient();

  Future<PaginatedResponse<PointTransaction>> getUserPointTransaction(
      {int? cursor,
      required int limit,
      required RedemptionHistorySort sortBy}) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getUserPointTransactions,
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
          'sortBy': sortBy.name,
        },
      );

      return ApiParser.parsePaginatedData(response,
          listKey: 'pointTransactions', fromJson: PointTransaction.fromJson);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
