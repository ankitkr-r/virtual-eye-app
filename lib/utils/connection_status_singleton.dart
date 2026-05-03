import 'dart:async'; // For StreamController/Stream
import 'dart:io'; // InternetAddress utility (Mobile/Desktop only)

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:virtual_eye/Widget/show_offline_popup.dart';
import 'package:virtual_eye/main.dart';

class ConnectionStatusSingleton {
  ConnectionStatusSingleton._internal();

  static final ConnectionStatusSingleton _instance =
  ConnectionStatusSingleton._internal();

  static ConnectionStatusSingleton get instance => _instance;

  bool hasConnection = false;
  bool isInitial = true;

  Connectivity connectivity = Connectivity();

  StreamController<bool> controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void showOfflinePopup() async {
    // Ensure context is valid before showing
    if (navigatorKey.currentContext != null) {
      showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: const ShowOfflinePopup(),
          ));
    }
  }

  void initialize() async {
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    _checkStatus(result);
    controller.sink.add(hasConnection);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  Future<bool> getConnectionStatus() async {
    return _checkStatus(await connectivity.checkConnectivity());
  }

  Future<bool> _checkStatus(List<ConnectivityResult> result) async {
    bool previousConnection = hasConnection;

    // 1. Initial check based on Connectivity Plus
    if (result.contains(ConnectivityResult.none)) {
      hasConnection = false;
    } else {
      // 2. Deep check (DNS lookup) for Mobile
      if (kIsWeb) {
        hasConnection = true;
      } else {
        try {
          // Added a timeout to prevent long hangs on slow BHU networks
          final lookupResult = await InternetAddress.lookup('google.com')
              .timeout(const Duration(seconds: 3));

          hasConnection = lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;
        } catch (_) {
          hasConnection = false;
        }
      }
    }

    // 3. Only sink and trigger popup if status ACTUALLY changed
    if (previousConnection != hasConnection || isInitial) {
      isInitial = false;
      controller.sink.add(hasConnection);

      // CRITICAL FIX: Only show the popup if hasConnection is FALSE
      if (!hasConnection) {
        showOfflinePopup();
      } else {
        // If connection is restored, close the dialog
        if (navigatorKey.currentContext != null && Navigator.canPop(navigatorKey.currentContext!)) {
          Navigator.pop(navigatorKey.currentContext!);
        }
      }
    }

    return hasConnection;
  }

  void disposeStream() => controller.close();
}
