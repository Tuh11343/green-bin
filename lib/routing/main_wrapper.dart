import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/bloc/app/app_cubit.dart';
import 'package:greenbin/bloc/app/app_state.dart';

import '../widgets/bottom_navigation_bar.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) =>
          previous.showBottomBar != current.showBottomBar ||
          previous.tabs != current.tabs,
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            extendBody: false,
            bottomNavigationBar: state.showBottomBar && state.tabs.isNotEmpty
                ? AppBottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              tabs: state.tabs,
              onTap: (index) {
                navigationShell.goBranch(index);
                // context.read<AppCubit>().changeTab(index);
              },
            )
                : null,
            body: SafeArea(child: navigationShell),
          ),
        );
      },
    );
  }
}
