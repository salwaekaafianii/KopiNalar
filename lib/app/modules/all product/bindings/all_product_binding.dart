import 'package:get/get.dart';
import '../controllers/all_product_controller.dart';
class AllProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllProductsController>(
      () => AllProductsController(),
    );
  }
}