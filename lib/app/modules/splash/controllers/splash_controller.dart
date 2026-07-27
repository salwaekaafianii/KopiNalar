import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class SplashController extends GetxController {
  final currentPage = RxInt(0);
  final PageController pageController = PageController();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  void _checkAuth() {
    // Jika user sudah login (token tersimpan), langsung ke halaman utama
    if (!_authService.isGuest.value) {
      Future.microtask(() => Get.offAllNamed('/main'));
    }
  }

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
