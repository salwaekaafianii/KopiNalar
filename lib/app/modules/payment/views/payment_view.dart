import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/button_styles.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),

        title: Text(
          'Pembayaran',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        centerTitle: true,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.white.withOpacity(0.08)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =====================================================
            // HEADER PEMBAYARAN
            // =====================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB74D), Color(0xFFF59E0B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(
                        controller.paymentIcon,
                        color: Colors.black,
                        size: 28,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          controller.paymentMethodName,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Divider(color: Colors.black.withOpacity(0.2)),

                  const SizedBox(height: 12),

                  Text(
                    'Total Pembayaran',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    controller.totalPayment,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =====================================================
            // INSTRUKSI PEMBAYARAN
            // =====================================================
            _buildPaymentInstructions(),

            const SizedBox(height: 20),

            // =====================================================
            // UPLOAD BUKTI
            // =====================================================
            if (controller.paymentMethodName != 'COD (Bayar di Tempat)')
              _buildUploadSection(),

            // =====================================================
            // COD
            // =====================================================
            if (controller.paymentMethodName == 'COD (Bayar di Tempat)')
              _buildCodSection(),

            const SizedBox(height: 24),

            // =====================================================
            // TOMBOL KONFIRMASI
            // =====================================================
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: kSecondaryButton(),
                  onPressed: () {
                    if (!controller.isSubmitting.value) {
                      controller.confirmPayment();
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.isSubmitting.value
                        ? Row(
                            key: const ValueKey("loading"),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Memproses Pembayaran...",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            key: const ValueKey("button"),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.paymentMethodName ==
                                        'COD (Bayar di Tempat)'
                                    ? "Konfirmasi Pesanan"
                                    : "Konfirmasi Pembayaran",
                                style: kButtonText(color: Colors.black),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // UPLOAD SECTION
  // =====================================================

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Icon(
                Icons.upload_file_rounded,
                size: 20,
                color: Color(0xFFFFB74D),
              ),

              const SizedBox(width: 8),

              Text(
                'Upload Bukti Pembayaran',

                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =====================================================
          // BAGIAN GAMBAR
          // =====================================================
          Obx(() {
            final Uint8List? bytes = controller.imageBytes.value;

            final bool isLoading = controller.isLoadingImage.value;

            print('OBX VIEW - bytes: ${bytes?.length}, isLoading: $isLoading');

            // =================================================
            // LOADING
            // =================================================

            if (isLoading) {
              return Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFB74D)),
                ),
              );
            }

            // =================================================
            // BELUM ADA GAMBAR
            // =================================================

            if (bytes == null) {
              return GestureDetector(
                onTap: () {
                  controller.pickImage();
                },

                child: Container(
                  width: double.infinity,
                  height: 160,

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),

                    borderRadius: BorderRadius.circular(12),

                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: Colors.white38,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Tap untuk upload bukti transfer',

                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),

                      Text(
                        'Format: JPG, PNG (max 5MB)',

                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // =================================================
            // SUDAH ADA GAMBAR
            // =================================================

            return Column(
              children: [
                // Tampilkan gambar langsung tanpa background
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFB74D),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.memory(
                      bytes,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) {
                        print('ERROR IMAGE MEMORY: $error');
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.red,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gambar gagal ditampilkan',
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // BUTTON GANTI & HAPUS
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: controller.pickImage,
                    icon: const Icon(Icons.photo_library_rounded, size: 18),
                    label: Text(
                      "Ganti Bukti",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFFB74D),
                      side: const BorderSide(color: Color(0xFFFFB74D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // =====================================================
  // COD SECTION
  // =====================================================

  Widget _buildCodSection() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFFFB74D).withOpacity(0.08),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.3)),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFFFFB74D),
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Pembayaran COD',

                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Bayar saat pesanan tiba di lokasi Anda',

                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // INSTRUKSI PEMBAYARAN
  // =====================================================

  Widget _buildPaymentInstructions() {
    if (controller.paymentMethodName == 'Transfer Bank Mandiri') {
      return _buildInstructionContainer(
        children: [
          _buildStep(1, 'Buka aplikasi Bank Mandiri / ATM Mandiri'),

          _buildStep(2, 'Pilih menu Transfer ke Rekening Bank Mandiri'),

          _buildStep(3, 'Masukkan nomor rekening tujuan:'),

          _buildAccountInfo(
            title: 'Bank Mandiri',
            number: '1234 5678 9012 3456',
          ),

          _buildStep(4, 'Masukkan nominal sesuai total pembayaran'),

          _buildStep(5, 'Konfirmasi dan selesaikan transfer'),

          _buildStep(6, 'Upload bukti transfer di bawah ini'),
        ],
      );
    }

    if (controller.paymentMethodName == 'E-Wallet DANA') {
      return _buildInstructionContainer(
        children: [
          _buildStep(1, 'Buka aplikasi DANA'),

          _buildStep(2, 'Pilih menu Kirim Uang'),

          _buildStep(3, 'Masukkan nomor DANA tujuan:'),

          _buildAccountInfo(title: 'DANA', number: '0812-3456-7890'),

          _buildStep(4, 'Masukkan nominal sesuai total pembayaran'),

          _buildStep(5, 'Konfirmasi dan selesaikan pembayaran'),

          _buildStep(6, 'Upload bukti pembayaran di bawah ini'),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  // =====================================================
  // INSTRUCTION CONTAINER
  // =====================================================

  Widget _buildInstructionContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Color(0xFFFFB74D),
              ),

              const SizedBox(width: 8),

              Text(
                'Cara Pembayaran',

                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ...children,
        ],
      ),
    );
  }

  // =====================================================
  // ACCOUNT INFO
  // =====================================================

  Widget _buildAccountInfo({required String title, required String number}) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(top: 4, bottom: 8),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.3)),
      ),

      child: Column(
        children: [
          Text(
            title,

            style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54),
          ),

          const SizedBox(height: 2),

          Text(
            number,

            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFB74D),
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            'a.n. Kopi Nalar Indonesia',

            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // STEP
  // =====================================================

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 22,
            height: 22,

            decoration: BoxDecoration(
              color: const Color(0xFFFFB74D),

              borderRadius: BorderRadius.circular(6),
            ),

            child: Center(
              child: Text(
                '$number',

                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,

              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
