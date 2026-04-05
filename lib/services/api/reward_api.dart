import 'package:dio/dio.dart';
import 'package:greenbin/services/http/dio_client.dart';
import 'package:greenbin/utils/api_parser.dart';

import '../../bloc/reward/reward_state.dart';
import '../../configs/api_endpoint.dart';
import '../../configs/api_error_handle.dart';
import '../../configs/exception.dart';
import '../../models/response/paginated_response.dart';
import '../../models/reward.dart';

class RewardApi {
  final DioClient _dioClient = DioClient();

  T _parseData<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final responseData = response.data;

    final actualData = responseData['data'];

    if (actualData == null) {
      throw ServerException(responseData['message']);
    }

    if (actualData is Map<String, dynamic> &&
        actualData.containsKey('reward')) {
      return fromJson(actualData['reward'] as Map<String, dynamic>);
    }

    return fromJson(actualData as Map<String, dynamic>);
  }

  Future<PaginatedResponse<Reward>> getAllReward({
    int? cursor,
    required int limit,
    required String search,
    required RewardSort sortBy,
    required RewardFilterCriteria filter,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getAllRewards,
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
          'search': search,
          'sortBy': sortBy.name,
          'filter': filter.name,
        },
      );

      return ApiParser.parsePaginatedData(response, listKey: 'rewards', fromJson: Reward.fromJson);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> redeemReward({required int rewardId}) async {
    try {
      await _dioClient
          .post(ApiEndpoints.redeemReward, data: {'rewardId': rewardId});
      return;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
