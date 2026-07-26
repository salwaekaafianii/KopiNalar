import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kopi_bnsp/app/modules/cart/controllers/cart_controller.dart';
import 'package:kopi_bnsp/app/modules/riwayat/views/riwayat_view.dart';
import 'package:kopi_bnsp/app/modules/cart/views/cart_view.dart';

import '../../home/views/home_view.dart';
import '../../all product/views/all_product_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            AllProductsView(),
            CartView(),
            RiwayatView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main navbar
            Container(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 12,
                left: 12,
                right: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.06)),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  color: const Color(0xFF222222),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(5, (index) {
                      final isActive = controller.currentIndex.value == index;
                      final icons = [
                        Icons.home_rounded,
                        Icons.grid_view_rounded,
                        Icons.shopping_cart_outlined,
                        Icons.history_rounded,
                        Icons.person_rounded,
                      ];
                      final activeIcons = [
                        Icons.home_rounded,
                        Icons.grid_view_rounded,
                        Icons.shopping_cart_outlined,
                        Icons.history_rounded,
                        Icons.person_rounded,
                      ];
                      final labels = [
                        'Beranda',
                        'Menu',
                        'Keranjang',
                        'Pesanan',
                        'Profil',
                      ];

                      // Badge untuk tab Keranjang (index 2)
                      final cartTotal = cartController.totalCartItems;
                      final showBadge = index == 2 && cartTotal > 0;

                      return GestureDetector(
                        onTap: () => controller.changeIndex(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFFFB74D).withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    isActive
                                        ? activeIcons[index]
                                        : icons[index],
                                    color: isActive
                                        ? const Color(0xFFFFB74D)
                                        : Colors.white54,
                                    size: 20,
                                  ),
                                  // Badge untuk keranjang
                                  if (showBadge)
                                    Positioned(
                                      right: -8,
                                      top: -6,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$cartTotal',
                                          style: GoogleFonts.poppins(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (isActive) ...[
                                const SizedBox(width: 6),
                                Text(
                                  labels[index],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFFB74D),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
