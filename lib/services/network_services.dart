import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  NetworkService._();

  static final NetworkService instance = NetworkService._();

  final Connectivity _connectivity = Connectivity();

  /// Current Internet Status
  Future<bool> hasInternet() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Listen Internet Changes
  Stream<bool> get onNetworkChanged {
    return _connectivity.onConnectivityChanged.map(
          (results) => !results.contains(ConnectivityResult.none),
    );
  }
}