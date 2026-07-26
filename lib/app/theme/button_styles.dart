import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Button primary full-width (putih)
ButtonStyle kPrimaryButton({Color bg = Colors.white, Color fg = Colors.black}) {
  return ElevatedButton.styleFrom(
    backgroundColor: bg,
    foregroundColor: fg,
    padding: const EdgeInsets.symmetric(vertical: 16),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  );
}

/// Button secondary full-width (kuning)
ButtonStyle kSecondaryButton() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFFFB74D),
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(vertical: 16),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  );
}

/// Button outline full-width
ButtonStyle kOutlineButton() {
  return OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    side: BorderSide(color: Colors.white.withOpacity(0.2)),
  );
}

/// Button small inline (sama persis ukurannya dgn primary — height 50, radius 14, bold 15)
ButtonStyle kSmallButton({Color bg = Colors.white, Color fg = Colors.black}) {
  return ElevatedButton.styleFrom(
    backgroundColor: bg,
    foregroundColor: fg,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    minimumSize: const Size(0, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  );
}

/// Text style button (bold 15)
TextStyle kButtonText({Color color = Colors.black}) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: color,
  );
}
