import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/pengaturan_controller.dart';

class PengaturanView extends GetView<PengaturanController> {
  const PengaturanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Pengaturan',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Profil',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Perbarui informasi akun kamu',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
            const SizedBox(height: 24),

            _buildLabel('Nama Lengkap'),
            const SizedBox(height: 6),
            _buildTextField(controller.nameController, 'Contoh: Salwa', TextInputType.text),

            const SizedBox(height: 18),

            _buildLabel('Email'),
            const SizedBox(height: 6),
            _buildTextField(controller.emailController, 'salwa@email.com', TextInputType.emailAddress),

            const SizedBox(height: 18),

            _buildLabel('Kata Sandi Baru'),
            const SizedBox(height: 6),
            Obx(() => TextField(
              controller: controller.newPasswordController,
              obscureText: controller.isPasswordHidden.value,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Min. 8 karakter, huruf besar, angka, simbol',
                hintStyle: GoogleFonts.poppins(fontSize: 11, color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withOpacity(0.03),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.white54,
                    size: 20,
                  ),
                  onPressed: () => controller.togglePasswordVisibility(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFFB74D), width: 1.5),
                ),
              ),
            )),

            const SizedBox(height: 18),

            _buildLabel('Konfirmasi Kata Sandi Baru'),
            const SizedBox(height: 6),
            Obx(() => TextField(
              controller: controller.confirmPasswordController,
              obscureText: controller.isConfirmPasswordHidden.value,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ketik ulang kata sandi baru',
                hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withOpacity(0.03),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordHidden.value
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.white54,
                    size: 20,
                  ),
                  onPressed: () => controller.toggleConfirmPasswordVisibility(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFFB74D), width: 1.5),
                ),
              ),
            )),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.saveProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB74D),
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: const Color(0xFFFFB74D).withOpacity(0.4),
                  disabledForegroundColor: Colors.black54,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text('Simpan Perubahan',
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70));
  }

  Widget _buildTextField(TextEditingController controller, String hint, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white30),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFB74D), width: 1.5),
        ),
      ),
    );
  }
}

