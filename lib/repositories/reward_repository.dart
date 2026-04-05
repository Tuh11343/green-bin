import 'package:greenbin/bloc/reward/reward_state.dart';
import 'package:greenbin/models/response/paginated_response.dart';

import '../../services/api/app_api.dart';
import '../configs/exception.dart';
import '../services/app_secure_storage.dart';
import 'app_event_bus.dart';

abstract class IRewardRepository {
  Future<PaginatedResponse> getAllRewards(
      {int? cursor,
      required int limit,
      required String search,
      required RewardSort sortBy,
      required RewardFilterCriteria filter});

  Future<void> redeemReward({required int rewardId, required int point});
}

class RewardRepository implements IRewardRepository {
  final _api = AppApi().reward;

  @override
  Future<PaginatedResponse> getAllRewards(
      {int? cursor,
      required int limit,
      required String search,
      required RewardSort sortBy,
      required RewardFilterCriteria filter}) async {
    try {
      return await _api.getAllReward(
          limit: limit,
          cursor: cursor,
          search: search,
          sortBy: sortBy,
          filter: filter);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }

  @override
  Future<void> redeemReward({required int rewardId, required int point}) async {
    try {
      final user = await AppStorage.getUser();
      if (user == null) {
        throw UnknownException("Không tìm thấy người dùng");
      }

      await _api.redeemReward(rewardId: rewardId);

      AppEventBus().emit(RedeemSuccessEvent(rewardId));

      return;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }
}
