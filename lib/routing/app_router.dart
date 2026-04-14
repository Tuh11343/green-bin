import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/screens/login/forgot_password_page.dart';
import 'package:greenbin/screens/login/login_page.dart';
import 'package:greenbin/screens/login/register_page.dart';
import 'package:greenbin/screens/notification/notification_page_user.dart';
import 'package:greenbin/screens/report/bin_selection/bin_selection_page.dart';
import 'package:greenbin/screens/report/create_report.dart';
import 'package:greenbin/screens/user_home/user_home.dart';
import 'package:greenbin/screens/user_setting/update_profile.dart';
import 'package:greenbin/screens/user_setting/user_setting.dart';

import '../models/bin.dart';
import '../models/enums.dart';
import '../screens/report/user_report_history/user_report_history_page.dart';
import '../screens/reward/reward_page.dart';
import '../services/app_secure_storage.dart';
import 'main_wrapper.dart';

class AppNavigation {
  AppNavigation._();

  static String initR = '/home';

  // 1 key duy nhất để test
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'homeNav');
  static final _notificationNavKey =
      GlobalKey<NavigatorState>(debugLabel: 'notificationNav');
  static final _userSettingKey =
      GlobalKey<NavigatorState>(debugLabel: '_userSettingKey');
  static final _rewardNavKey =
      GlobalKey<NavigatorState>(debugLabel: 'rewardNavKey');

  static String _getHomeByRole(UserRole role) {
    switch (role) {
      case UserRole.resident:
        return '/home';
      case UserRole.collector:
        return '/collector';
      case UserRole.admin:
        return '/admin';
    }
  }

  static final GoRouter router = GoRouter(
    initialLocation: initR,
    debugLogDiagnostics: false,
    //bật nếu muốn kiểm tra điều hướng
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) async {
      // return '/binList';
      final user = await AppStorage.getUser();

      final isAuthRoute = state.matchedLocation.startsWith('/login');

      if (user == null) {
        return isAuthRoute ? null : '/login';
      }

      if (isAuthRoute) {
        return _getHomeByRole(user.role);
      }

      if (state.matchedLocation == '/' || state.matchedLocation == '/home') {
        return _getHomeByRole(user.role);
      }

      return null;
    },
    routes: [
      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
          routes: [
            GoRoute(
              path: 'register',
              name: 'register',
              builder: (context, state) => const RegisterPage(),
            ),
            GoRoute(
              path: 'forgotPassword',
              name: 'forgotPassword',
              builder: (context, state) => const ForgotPasswordPage(),
            ),
          ]),

      // GoRoute(
      //     path: '/binList',
      //     name: 'binList',
      //     builder: (context, state) => const BinListSelectionPage()),

      // Các màn hình chính nằm trong Shell (Có BottomBar)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const UserHomePage(),
                  routes: [
                    GoRoute(
                      path: 'userReportHistory',
                      name: 'userReportHistory',
                      builder: (context, state) =>
                          const UserReportHistoryPage(),
                    ),
                    GoRoute(
                        path: 'report',
                        name: 'report',
                        builder: (context, state) =>
                            const BinListSelectionPage(),
                        routes: [
                          GoRoute(
                              path: 'createReport',
                              name: 'createReport',
                              builder: (context, state) {
                                final bin = state.extra as Bin;
                                return CreateReportPage(bin: bin);
                              }),
                        ]),
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _notificationNavKey,
            routes: [
              GoRoute(
                path: '/notification',
                name: 'notification',
                builder: (context, state) => const UserNotificationPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rewardNavKey,
            routes: [
              GoRoute(
                path: '/reward',
                name: 'reward',
                builder: (context, state) => const RewardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _userSettingKey,
            routes: [
              GoRoute(
                  path: '/userSetting',
                  name: 'userSetting',
                  builder: (context, state) => const UserSettingsPage(),
                  routes: [
                    GoRoute(
                      path: 'updateProfile',
                      name: 'updateProfile',
                      builder: (context, state) => const UpdateProfilePage(),
                    ),
                  ]),
            ],
          ),
        ],
      ),
    ],
  );
}
