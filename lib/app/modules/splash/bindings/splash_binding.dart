import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Menginisialisasi SplashController saat SplashView dibuka
    Get.lazyPut<SplashController>(() => SplashController());
  }
}