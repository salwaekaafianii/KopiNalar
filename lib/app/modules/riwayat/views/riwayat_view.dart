import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Riwayat Pesanan',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
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
                  Icon(Icons.lock_outline_rounded,
                      size: 80, color: Colors.white.withOpacity(0.1)),
                  const SizedBox(height: 20),
                  Text('Login untuk Melihat Riwayat',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Masuk ke akunmu untuk melihat riwayat pesanan',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.white54),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Masuk',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFFB74D)),
          );
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_rounded, size: 80, color: Colors.white.withOpacity(0.1)),
                const SizedBox(height: 16),
                Text('Belum ada pesanan',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white54)),
                const SizedBox(height: 8),
                Text('Pesanan Anda akan muncul di sini',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white24)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.loadOrders(),
          color: const Color(0xFFFFB74D),
          backgroundColor: const Color(0xFF1A1A1A),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              final status = controller.getStatusLabel(order['status']?.toString());
              Color statusColor = Colors.green;

              final items = order['items'] as List<dynamic>? ?? [];
              final firstItem = items.isNotEmpty ? items.first as Map<String, dynamic> : null;
              final itemNames = items.map((item) {
                final i = item as Map<String, dynamic>;
                final qty = i['quantity'] ?? 1;
                return '${i['name'] ?? ''}${qty > 1 ? ' x$qty' : ''}';
              }).join(', ');

              return GestureDetector(
                onTap: () => Get.toNamed(Routes.orderDetail, arguments: order),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.getInvoiceNumber(order),
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(status,
                              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(controller.formatDate(order['createdAt']?.toString()),
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.white38)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: firstItem != null && firstItem['image']?.toString().isNotEmpty == true
                                ? Image.network(firstItem['image'], width: 50, height: 50, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 50, height: 50,
                                      color: Colors.white.withOpacity(0.05),
                                      child: const Icon(Icons.image, color: Colors.white24, size: 24),
                                    ))
                                : Container(
                                    width: 50, height: 50,
                                    color: Colors.white.withOpacity(0.05),
                                    child: const Icon(Icons.image, color: Colors.white24, size: 24),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(itemNames,
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white38)),
                          Text(controller.getFormatRupiah(order['totalPayment']),
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFFFFB74D))),
                        ],
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

