import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../theme/snackbar_helper.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final apiService = ApiService();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Validasi email: harus mengandung @
  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  // Fungsi untuk proses login biasa
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validasi: tidak boleh kosong
    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar('Peringatan', 'Email dan kata sandi tidak boleh kosong');
      return;
    }

    // Validasi: format email harus valid
    if (!_isValidEmail(email)) {
      showCustomSnackbar('Email Tidak Valid', 'Masukkan email yang valid');
      return;
    }

    try {
      isLoading.value = true;
      final response = await apiService.login(email: email, password: password);
      showCustomSnackbar('Sukses', response['message'] ?? 'Berhasil Masuk!');
      Get.offAllNamed('/main');
    } catch (e) {
      showCustomSnackbar('Gagal', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk login dengan Google
  void loginWithGoogle() {
    // TODO: Tambahkan logika Google Sign-In di sini
    showCustomSnackbar('Informasi', 'Fitur Masuk dengan Google ditekan');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
