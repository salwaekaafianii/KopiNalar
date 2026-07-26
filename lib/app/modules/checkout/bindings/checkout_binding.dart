import 'package:get/get.dart';

import '../../alamat/controllers/alamat_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(),
    );

    Get.lazyPut<AlamatController>(
      () => AlamatController(),
    );
  }
}