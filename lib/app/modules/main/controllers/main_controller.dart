import 'package:get/get.dart';

class MainController extends GetxController {
  final currentIndex = RxInt(0);

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}