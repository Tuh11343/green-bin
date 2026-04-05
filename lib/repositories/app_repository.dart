import 'package:greenbin/repositories/auth_repository.dart';
import 'package:greenbin/repositories/point_transaction_repository.dart';
import 'package:greenbin/repositories/report_repository.dart';
import 'package:greenbin/repositories/reward_repository.dart';
import 'package:greenbin/repositories/user_repository.dart';

import 'app_notification_repository.dart';
import 'bin_repository.dart';

class AppRepository {
  static final AppRepository _instance = AppRepository._internal();

  factory AppRepository() {
    return _instance;
  }

  late final AuthRepository auth;
  late final RewardRepository reward;
  late final ReportRepository report;
  late final UserRepository user;
  late final BinRepository bin;
  late final AppNotificationRepository appNotification;
  late final PointTransactionRepository pointTransaction;

  AppRepository._internal() {
    auth = AuthRepository();
    user = UserRepository();
    reward = RewardRepository();
    report = ReportRepository();
    bin = BinRepository();
    appNotification = AppNotificationRepository();
    pointTransaction = PointTransactionRepository();
  }
}
