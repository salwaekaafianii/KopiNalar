import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../theme/snackbar_helper.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;
  final apiService = ApiService();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Validasi email: harus mengandung @
  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
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

  // Fungsi untuk proses pendaftaran akun baru
  Future<void> register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validasi: semua field harus diisi
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showCustomSnackbar('Peringatan', 'Semua kolom harus diisi!');
      return;
    }

    // Validasi: email harus valid
    if (!_isValidEmail(email)) {
      showCustomSnackbar('Email Tidak Valid', 'Email harus mengandung "@" dan domain yang valid');
      return;
    }

    // Validasi: password harus sesuai aturan
    final passwordError = _validatePassword(password);
    if (passwordError != null) {
      showCustomSnackbar('Kata Sandi Lemah', passwordError);
      return;
    }

    // Validasi: konfirmasi password harus cocok
    if (password != confirmPassword) {
      showCustomSnackbar('Peringatan', 'Konfirmasi kata sandi tidak cocok!');
      return;
    }

    try {
      isLoading.value = true;
      final response = await apiService.register(
        name: name,
        email: email,
        password: password,
      );
      showCustomSnackbar('Sukses', response['message'] ?? 'Akun berhasil didaftarkan!');

      // Cek role user
      final role = response['user']?['role'] ?? 'user';
      if (role == 'admin') {
        Get.offAllNamed('/admin');
      } else {
        Get.offAllNamed('/main');
      }
    } catch (e) {
      showCustomSnackbar('Gagal', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk daftar/masuk dengan Google
  void registerWithGoogle() {
    // TODO: Tambahkan logika Google Sign-In di sini
    showCustomSnackbar('Informasi', 'Fitur Masuk dengan Google ditekan');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
