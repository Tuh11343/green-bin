import 'package:greenbin/services/api/point_transaction_api.dart';
import 'package:greenbin/services/api/report_api.dart';
import 'package:greenbin/services/api/reward_api.dart';
import 'package:greenbin/services/api/user_api.dart';

import '../http/dio_client.dart';
import 'app_notification_api.dart';
import 'auth_api.dart';
import 'bin_api.dart';

class AppApi {
  static final AppApi _instance = AppApi._internal();
  final dioClient = DioClient();

  factory AppApi() {
    return _instance;
  }

  late final RewardApi reward;
  late final AuthApi auth;
  late final ReportApi report;
  late final UserApi user;
  late final BinApi bin;
  late final AppNotificationApi appNotification;
  late final PointTransactionApi pointTransaction;

  AppApi._internal() {
    reward = RewardApi();
    user = UserApi();
    auth = AuthApi(dioClient);
    report = ReportApi();
    bin = BinApi();
    appNotification = AppNotificationApi();
    pointTransaction = PointTransactionApi();
  }
}
