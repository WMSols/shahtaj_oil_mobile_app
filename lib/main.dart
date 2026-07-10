import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/app/app.dart';
import 'package:shahtaj_oil_mobile_app/core/app/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught error: $error\n$stack');
    return true;
  };

  await runZonedGuarded(
    () async {
      await AppInitializer.setup();
      runApp(const ShahtajOilApp());
    },
    (error, stack) => debugPrint('Zone error: $error\n$stack'),
  );
}
