import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/admin_controller.dart';
import 'dashboard_view.dart';
import 'orders_view.dart';
import 'products_view.dart';
import 'profile_admin_view.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Obx(() {
        final pages = <Widget>[
          const DashboardView(),
          const OrdersView(),
          const ProductsView(),
          const ProfileAdminView(),
        ];
        return IndexedStack(
          index: controller.currentNavIndex.value,
          children: pages,
        );
      }),
      bottomNavigationBar: Obx(
        () => Container(
          padding: const EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8),
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
                children: List.generate(4, (index) {
                  final isActive = controller.currentNavIndex.value == index;
                  final icons = [
                    Icons.dashboard_rounded,
                    Icons.receipt_long_rounded,
                    Icons.coffee_rounded,
                    Icons.person_rounded,
                  ];
                  final labels = [
                    'Dashboard',
                    'Pesanan',
                    'Produk',
                    'Profil',
                  ];

                  return GestureDetector(
                    onTap: () => controller.changeNavIndex(index),
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
                          Icon(
                            icons[index],
                            color: isActive
                                ? const Color(0xFFFFB74D)
                                : Colors.white54,
                            size: 20,
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
      ),
    );
  }
}

