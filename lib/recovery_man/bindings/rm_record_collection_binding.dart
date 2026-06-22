import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/rm_record_collection_controller.dart';

class RmRecordCollectionBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(RmRecordCollectionController.new);
}
