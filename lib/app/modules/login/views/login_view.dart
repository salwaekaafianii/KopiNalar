import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/button_styles.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 24.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Text(
                        'Selamat Datang Kembali',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masuk untuk melanjutkan pesanan kopi favoritmu.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Form Email
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

                      // Form Password
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
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.white30,
                            ),
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
                      const SizedBox(height: 24),

                      // Tombol Masuk
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton(
                            style: kPrimaryButton(),
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    controller.login();
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
                                : Text('Masuk', style: kButtonText()),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tombol Google
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: kOutlineButton(),
                          onPressed: () {
                            controller.loginWithGoogle();
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
                                  'Masuk dengan Google',
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

                      // Opsi Daftar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/register'),
                            child: Text(
                              'Daftar',
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
            );
          },
        ),
      ),
    );
  }
}
