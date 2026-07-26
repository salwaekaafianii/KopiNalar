import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/button_styles.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 24.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================
                  // JUDUL
                  // =========================
                  Text(
                    'Buat Akun Baru',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Daftar untuk menikmati kemudahan memesan kopi di Kopi Nalar.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // =========================
                  // NAMA
                  // =========================
                  Text(
                    'Nama Lengkap',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: controller.nameController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Nama Anda',
                      hintStyle: GoogleFonts.poppins(color: Colors.white30),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =========================
                  // EMAIL
                  // =========================
                  Text(
                    'Email',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'nama@email.com',
                      hintStyle: GoogleFonts.poppins(color: Colors.white30),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =========================
                  // PASSWORD
                  // =========================
                  Text(
                    'Kata Sandi',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Obx(
                    () => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: GoogleFonts.poppins(color: Colors.white30),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () =>
                              controller.togglePasswordVisibility(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =========================
                  // KONFIRMASI KATA SANDI
                  // =========================
                  Text(
                    'Konfirmasi Kata Sandi',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Obx(
                    () => TextField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: GoogleFonts.poppins(color: Colors.white30),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () =>
                              controller.toggleConfirmPasswordVisibility(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // TOMBOL DAFTAR
                  // =========================
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        style: kPrimaryButton(),
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller.register();
                              },
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text('Daftar Sekarang', style: kButtonText()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =========================
                  // GOOGLE
                  // =========================
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: kOutlineButton(),
                      onPressed: () {
                        controller.registerWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            width: 22,
                            height: 22,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(width: 8),

                          Flexible(
                            child: Text(
                              'Daftar dengan Google',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kButtonText(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // LOGIN LINK
                  // =========================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Sudah punya akun? ',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13.5,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Get.offNamed('/login');
                        },
                        child: Text(
                          'Masuk',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
