import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final currentPage = RxInt(0);
  final PageController pageController = PageController();

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishSplash();
    }
  }

  void finishSplash() {
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}