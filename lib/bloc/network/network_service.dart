import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';


class InternetChecker {
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  final InternetChecker _internetChecker = InternetChecker();

  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      return false;
    }

    return await _internetChecker.hasInternet();
  }
}