import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Menampilkan snackbar seragam di seluruh aplikasi.
///
/// Posisi: TOP
/// Background: putih
/// Font: Poppins (dari google_fonts)
/// Border radius: 12
/// Margin: 16 di kiri-kanan
void showCustomSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    colorText: const Color(0xFF1A1A1A),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
    titleText: Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
    ),
    messageText: Text(
      message,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF555555),
      ),
    ),
  );
}

