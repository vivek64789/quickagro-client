import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityProvider extends ChangeNotifier {
  bool? _isNear;
  late StreamSubscription<dynamic> _streamSubscription;

  getIsNear() {
    return _isNear;
  }

  StreamSubscription<dynamic> getStreamSubscription() {
    return _streamSubscription;
  }

  Future<void> listenProximitySensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      _isNear = (event > 0) ? true : false;
      notifyListeners();
    });
  }
}
