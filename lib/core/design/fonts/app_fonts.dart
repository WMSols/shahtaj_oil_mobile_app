import 'package:get/get.dart';

class AppFonts {
  static const String inter = 'Inter';
  static const String urdu = 'Urdu';

  static String get mainFont =>
      Get.locale?.languageCode == 'ur' ? urdu : inter;
}
