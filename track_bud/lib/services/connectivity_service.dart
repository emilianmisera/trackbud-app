import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = true; // By default assume online
  bool get isOnline => _isOnline;

  ConnectivityService() {
    // Subscribe to the connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Update connection status and notify listeners
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _isOnline = result.any((status) => status != ConnectivityResult.none);
    notifyListeners();
  }

  // Dispose the subscription to avoid memory leaks
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}