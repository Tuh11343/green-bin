import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../configs/app_color.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Giả lập check login/loading data trong 2 giây
    await Future.delayed(const Duration(seconds: 2));

    // Điều hướng bằng GoRouter
    if (mounted) {
      // context.go('/login'); // Hoặc '/' nếu đã login
      // context.push('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo hoặc Animation (Lottie)
            Icon(Icons.recycling, size: 100, color: Colors.white),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}