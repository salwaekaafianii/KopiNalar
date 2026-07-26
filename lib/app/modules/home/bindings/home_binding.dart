import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Mendaftarkan HomeController menggunakan lazyPut
    Get.lazyPut<HomeController>(() => HomeController());
  }
}