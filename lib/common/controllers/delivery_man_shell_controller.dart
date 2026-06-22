import 'package:get/get.dart';

class DeliveryManShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void setIndex(int index) => currentIndex.value = index;
}
