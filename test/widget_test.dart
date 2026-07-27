import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shahtaj_oil_mobile_app/common/views/splash/splash_screen.dart';
import 'package:shahtaj_oil_mobile_app/core/app/app.dart';

import 'package:shahtaj_oil_mobile_app/core/services/locale_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await dotenv.load(fileName: '.env');
    FlutterSecureStorage.setMockInitialValues({});
    Get.reset();
    final storage = StorageService();
    Get.put(storage, permanent: true);
    final localeService = LocaleService(storage);
    Get.put(localeService, permanent: true);
  });

  tearDown(Get.reset);

  testWidgets('App boots to splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ShahtajOilApp());
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  });
}
