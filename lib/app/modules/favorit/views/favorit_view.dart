import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/services/auth_service.dart';
import '../controllers/favorit_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  String formatRupiah(String price) {
    final number = int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

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
        centerTitle: true,
        title: Text(
          "Produk Favorit",
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
        final authService = Get.find<AuthService>();

        // =========================
        // GUEST - tampilkan pesan login
        // =========================
        if (authService.isGuest.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Login untuk Melihat Favorit',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masuk ke akunmu untuk menyimpan menu favorit',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // =========================
        // LOADING
        // =========================
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        // =========================
        // KOSONG
        // =========================
        if (controller.favoriteItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white38,
                  size: 80,
                ),
                const SizedBox(height: 15),
                Text(
                  "Belum Ada Favorit",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Tambahkan menu favoritmu\ndengan menekan ikon ❤️",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFFFB74D),
          onRefresh: () => controller.loadFavorites(),
          child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.favoriteItems.length,
          itemBuilder: (context, index) {
            final item = controller.favoriteItems[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(.08),
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => controller.goToDetail(item),
                child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item["image"],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.white.withOpacity(0.05),
                          child: const Center(
                            child: Icon(Icons.coffee, color: Color(0xFFFFB74D)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item["category"],
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatRupiah(item["price"]),
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFFFB74D),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      controller.removeFavorite(item);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              ),
            );
          },
        ),
        );
      }),
    );
  }
}
