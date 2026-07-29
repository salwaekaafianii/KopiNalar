import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kopi_bnsp/app/routes/app_pages.dart';
import '../../../data/services/auth_service.dart';
import '../controllers/admin_controller.dart';

class ProfileAdminView extends GetView<AdminController> {
  const ProfileAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            
            const SizedBox(width: 10),
            Text(
              'Profil Admin',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Avatar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFB74D), width: 2),
              ),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.white.withOpacity(0.05),
                child: Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 52,
                  color: const Color(0xFFFFB74D).withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name
            Obx(
              () => Text(
                controller.adminName.value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Email
            Obx(
              () => Text(
                controller.adminEmail.value,
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
              ),
            ),
            const SizedBox(height: 6),

            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFFB74D).withOpacity(0.3),
                ),
              ),
              child: Text(
                'Administrator',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFFB74D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Menu items
            _buildMenuItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              subtitle: 'Lihat ringkasan statistik',
              onTap: () => controller.changeNavIndex(0),
            ),
            _buildMenuItem(
              icon: Icons.receipt_long_rounded,
              title: 'Kelola Pesanan',
              subtitle: 'Atur & pantau pesanan',
              onTap: () => controller.changeNavIndex(1),
            ),
            _buildMenuItem(
              icon: Icons.coffee_rounded,
              title: 'Kelola Produk',
              subtitle: 'Tambah, edit, atau hapus produk',
              onTap: () => controller.changeNavIndex(2),
            ),

            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.dialog(
                    Dialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundColor: Color(0x22FF5252),
                              child: Icon(
                                Icons.logout_rounded,
                                color: Colors.redAccent,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              "Keluar Akun",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Apakah Anda yakin ingin keluar dari akun admin?",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Get.back(),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(.2),
                                      ),
                                    ),
                                    child: Text(
                                      "Batal",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    onPressed: () async {
                                      Get.back();
                                      await authService.clearSession();
                                      Get.offAllNamed(Routes.login);
                                    },
                                    child: Text(
                                      "Keluar",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
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
                  );
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: Text(
                  'Keluar',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Version
            Text(
              'KopiNalar Admin v1.0.0',
              style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB74D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFFFB74D), size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.white24,
          size: 22,
        ),
      ),
    );
  }
}
