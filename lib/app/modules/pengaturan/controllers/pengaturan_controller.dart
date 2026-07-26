import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kopi_bnsp/app/data/services/auth_service.dart';
import 'package:kopi_bnsp/app/data/services/api_service.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/snackbar_helper.dart';

class PengaturanController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final userName = RxString('');
  final userEmail = RxString('');

  AuthService get _authService => Get.find<AuthService>();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadLocalProfile();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> loadLocalProfile() async {
    final user = await _authService.getUser();
    if (user != null) {
      userName.value = user['name'] ?? '';
      userEmail.value = user['email'] ?? '';
    }
    nameController.text = userName.value;
    emailController.text = userEmail.value;
  }

  // Validasi password: min 8 karakter, ada huruf besar, angka, dan simbol
  String? _validatePassword(String password) {
    if (password.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Kata sandi harus mengandung huruf besar';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Kata sandi harus mengandung angka';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_]'))) {
      return 'Kata sandi harus mengandung simbol';
    }
    return null; // valid
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      showCustomSnackbar('Peringatan', 'Nama dan email tidak boleh kosong');
      return;
    }

    // Validasi password jika diisi
    if (newPassword.isNotEmpty) {
      final passwordError = _validatePassword(newPassword);
      if (passwordError != null) {
        showCustomSnackbar('Kata Sandi Lemah', passwordError);
        return;
      }

      if (newPassword != confirmPassword) {
        showCustomSnackbar('Peringatan', 'Konfirmasi kata sandi tidak cocok!');
        return;
      }
    }

    try {
      isLoading.value = true;

      // Kirim password hanya jika diisi
      final response = await _apiService.updateProfile(
        name: name,
        email: email,
        password: newPassword.isNotEmpty ? newPassword : null,
      );

      if (response['user'] != null) {
        userName.value = response['user']['name'] ?? name;
        userEmail.value = response['user']['email'] ?? email;
      }

      isLoading.value = false;

      final msg = newPassword.isNotEmpty
          ? 'Kata sandi berhasil diperbarui'
          : 'Profil berhasil diperbarui';
      showCustomSnackbar('Berhasil', msg);

      await Future.delayed(const Duration(seconds: 2));

      Get.offNamed(Routes.main);
    } catch (e) {
      isLoading.value = false;
      showCustomSnackbar('Gagal', e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
