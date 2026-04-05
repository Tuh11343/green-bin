import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../models/app_tab.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final List<AppTab> tabs;
  final Function(int) onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      height: 60.0,
      items: tabs.map((tab) => Icon(tab.icon, size: 30, color: Colors.white)).toList(),
      color: Colors.green.shade600, // Màu của thanh bar
      buttonBackgroundColor: Colors.green.shade800, // Màu của nút đang chọn
      backgroundColor: Colors.transparent, // Màu nền phía sau (thường để transparent)
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      onTap: onTap,
      letIndexChange: (index) => true,
    );
  }
}