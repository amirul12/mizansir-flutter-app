// File: lib/core/services/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity
class ConnectivityService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Controller for broadcasting connectivity changes
  final _connectivityController = StreamController<bool>.broadcast();

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Initialize connectivity service
  Future<void> init() async {
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final isConnected = _isConnected(results);
        _connectivityController.add(isConnected);
      },
    );
  }

  /// Check if device is currently connected
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _isConnected(results);
    } catch (e) {
      return false;
    }
  }

  /// Stream of connectivity status changes
  Stream<bool> get onConnectivityChanged =>
      _connectivityController.stream;

  /// Parse connectivity results to boolean
  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) =>
        result != ConnectivityResult.none);
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
  }
}
