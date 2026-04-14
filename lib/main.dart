import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/bloc/app/app_cubit.dart';
import 'package:greenbin/bloc/report/bin_selection/bin_list_bloc.dart';
import 'package:greenbin/configs/api_endpoint.dart';
import 'package:greenbin/repositories/app_repository.dart';
import 'package:greenbin/routing/app_router.dart';
import 'package:greenbin/services/app_secure_storage.dart';
import 'package:greenbin/services/notification/notification_service.dart';
import 'package:greenbin/services/notification/notification_socket_service.dart';

import 'bloc/auth/auth_cubit.dart';
import 'bloc/network/network_cubit.dart';
import 'bloc/network/network_service.dart';
import 'bloc/notification/app_notification_cubit.dart';
import 'bloc/point_transaction/redemption_history_cubit.dart';
import 'bloc/report/report_cubit.dart';
import 'bloc/report/user_report_history/user_report_history_bloc.dart';
import 'bloc/reward/reward_bloc.dart';
import 'bloc/user/user_cubit.dart';
import 'firebase_options.dart';
import 'models/bin.dart';
import 'models/collection_task.dart';
import 'models/enums.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 5));
    await AppStorage.init();
    tz.initializeTimeZones();
    await NotificationService().initialize();
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final notificationSocketService = NotificationSocketService(
    baseUrl: ApiEndpoints.baseUrl,
    // userId: 0, // placeholder, sẽ update sau khi login
  );

// 2. Tạo dữ liệu giả lập cho Nhiệm vụ thu gom (CollectionTask)
  final CollectionTask mockTask = CollectionTask(
    id: 2024001,
    binId: 101,
    userId: 1,
    // ID của người thu gom
    status: CollectionTaskStatus.inProgress,
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    startedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    notes: 'Thùng rác khu vực cổng chính, cần dọn dẹp thêm xung quanh.',
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NetworkCubit(NetworkService()),
        ),
        BlocProvider(create: (context) => RewardBloc(repository: AppRepository())),
        BlocProvider(create: (context) => AuthCubit(AppRepository())),
        BlocProvider(create: (context) => UserCubit(AppRepository())),
        BlocProvider(create: (context) => ReportCubit(AppRepository())),
        BlocProvider(create: (context) => AppCubit(AppRepository())),
        BlocProvider(create: (context) => RedemptionHistoryBloc(repository: AppRepository())),
        BlocProvider(create: (context) => UserReportHistoryBloc(repository: AppRepository())),
        BlocProvider(
          create: (_) => AppNotificationCubit(
            repo: AppRepository(),
            socketService: notificationSocketService,
            notificationService: NotificationService(),
          ),
        ),
        BlocProvider(create: (context) => BinListBloc(repo: AppRepository())),


      ],
      child: MaterialApp.router(
        title: 'Green Bin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppNavigation.router,
      ),
    );
  }
}


