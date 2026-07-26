import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../all product/controllers/all_product_controller.dart';
import '../../favorit/controllers/favorit_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../riwayat/controllers/riwayat_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<AllProductsController>(
      () => AllProductsController(),
    );
    Get.lazyPut<FavoriteController>(
      () => FavoriteController(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<RiwayatController>(
      () => RiwayatController(),
    );
  }
}
