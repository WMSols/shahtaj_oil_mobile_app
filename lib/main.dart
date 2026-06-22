import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/app/app.dart';
import 'package:shahtaj_oil_mobile_app/core/app/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.setup();
  runApp(const ShahtajOilApp());
}
