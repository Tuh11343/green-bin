import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_service.dart';

enum NetworkStatus {
  online,
  offline,
}

class NetworkCubit extends Cubit<NetworkStatus> {
  final NetworkService networkService;
  StreamSubscription? _subscription;

  NetworkCubit(this.networkService) : super(NetworkStatus.online) {
    _init();
  }

  void _init() async {
    final connected = await networkService.isConnected();
    emit(connected ? NetworkStatus.online : NetworkStatus.offline);

    _subscription =
        networkService.onConnectivityChanged.listen((ConnectivityResult _) async {
          final hasInternet = await networkService.isConnected();

          emit(hasInternet ? NetworkStatus.online : NetworkStatus.offline);
        });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}