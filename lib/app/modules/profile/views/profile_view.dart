import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kopi_bnsp/app/modules/favorit/views/favorit_view.dart';
import 'package:kopi_bnsp/app/modules/tentang/views/tentang_view.dart';
import 'package:kopi_bnsp/app/routes/app_pages.dart';
import '../../../data/services/auth_service.dart';
import '../controllers/profile_controller.dart';
import 'package:kopi_bnsp/app/modules/pengaturan/views/pengaturan_view.dart';
import 'package:kopi_bnsp/app/modules/pengaturan/bindings/pengaturan_binding.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Profil Saya",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1),
        ),
      ),
      body: Obx(() {
        // Jika guest, tampilkan pesan login
        if (authService.isGuest.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      size: 60,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Kamu sedang dalam mode Tamu',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masuk untuk menikmati fitur lengkap',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(Routes.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB74D),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Masuk',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.register),
                        child: Text(
                          'Daftar',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFFFB74D),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        // Tampilan untuk user yang sudah login
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Avatar & Info
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFB74D), width: 2),
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  child: Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: const Color(0xFFFFB74D).withOpacity(0.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    controller.userName.value,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 17, // lebih kecil
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  controller.userEmail.value,
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Menu Items
              _buildMenuItem(
                icon: Icons.favorite_rounded,
                title: 'Favorit',
                subtitle: 'Produk favorit kamu',
                onTap: () => Get.to(() => const FavoriteView()),
              ),
              // Admin Panel - hanya untuk admin
              Obx(() {
                if (authService.isGuest.value) return const SizedBox.shrink();
                return FutureBuilder<Map<String, dynamic>?>(
                  future: authService.getUser(),
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    final role = user?['role'] ?? '';
                    if (role != 'admin') return const SizedBox.shrink();
                    return _buildMenuItem(
                      icon: Icons.admin_panel_settings_rounded,
                      title: 'Admin Panel',
                      subtitle: 'Kelola pesanan & dashboard',
                      onTap: () => Get.toNamed(Routes.admin),
                    );
                  },
                );
              }),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Alamat Saya',
                subtitle: 'Atur alamat pengiriman',
                onTap: () => Get.toNamed(Routes.alamat),
              ),
              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'Tentang Kami',
                subtitle: 'Informasi aplikasi',
                onTap: () => Get.to(() => const TentangView()),
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                subtitle: 'Edit profil akun kamu',
                onTap: () async {
                  await Get.to(
                    () => const PengaturanView(),
                    binding: PengaturanBinding(),
                  );

                  controller.loadProfile();
                },
              ),

              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.logout(),
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
            ],
          ),
        );
      }),
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
