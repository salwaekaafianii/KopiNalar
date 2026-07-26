import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kopi_bnsp/app/data/services/auth_service.dart';
import 'package:kopi_bnsp/app/data/services/api_service.dart';
import 'package:kopi_bnsp/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  AuthService get _authService => Get.find<AuthService>();
  final ApiService _apiService = ApiService();
  final userName = RxString('');
  final userEmail = RxString('');
  final userAvatar = RxString('');
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    // Ambil dari storage dulu
    final user = await _authService.getUser();
    if (user != null) {
      userName.value = user['name'] ?? '';
      userEmail.value = user['email'] ?? '';
    }

    // Coba ambil dari backend untuk data terbaru
    try {
      isLoading.value = true;
      final response = await _apiService.getProfile();
      if (response['user'] != null) {
        final name = response['user']['name'] ?? '';
        final email = response['user']['email'] ?? '';
        userName.value = name;
        userEmail.value = email;
        final token = await _authService.getToken();
        if (token != null) {
          await _authService.saveSession(
            token: token,
            user: {'id': response['user']['id'], 'name': name, 'email': email},
          );
        }
      }
    } catch (e) {
      print("Gagal fetch profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Keluar dari Akun?',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah Anda yakin ingin keluar dari akun Anda?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(color: Colors.white.withOpacity(0.12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _authService.clearSession();
                        Get.back();
                        Get.offAllNamed(Routes.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Keluar',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
