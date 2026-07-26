import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      // APP BAR
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
          'Notifikasi',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        centerTitle: true,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1),
        ),
      ),

      // BODY
      body: Obx(() {
        // Jika tidak ada notifikasi
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 80,
                  color: Colors.white.withOpacity(0.1),
                ),

                const SizedBox(height: 16),

                Text(
                  'Tidak ada notifikasi',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Notifikasi akan muncul di sini',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white24,
                  ),
                ),
              ],
            ),
          );
        }

        // LIST NOTIFIKASI
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,

          itemBuilder: (context, index) {
            final notif = controller.notifications[index];

            return Dismissible(
              // Key unik untuk setiap notifikasi
              key: Key('${notif['title']}_${notif['time']}_$index'),

              // Hanya bisa digeser dari kanan ke kiri
              direction: DismissDirection.endToStart,

              // Background yang muncul ketika digeser
              background: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,

                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 26,
                ),
              ),

              // Fungsi ketika notifikasi selesai digeser
              onDismissed: (direction) {
                controller.deleteNotification(index);

                Get.snackbar(
                  '',
                  '',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  duration: const Duration(seconds: 2),

                  titleText: Text(
                    'Notifikasi Dihapus',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  messageText: Text(
                    'Notifikasi berhasil dihapus',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                );
              },

              // CARD NOTIFIKASI
              child: GestureDetector(
                // Tap notifikasi untuk menandai sudah dibaca
                onTap: () => controller.markAsRead(index),

                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: notif['isRead']
                        ? Colors.white.withOpacity(0.02)
                        : const Color(0xFFFFB74D).withOpacity(0.05),

                    borderRadius: BorderRadius.circular(14),

                    border: Border.all(
                      color: notif['isRead']
                          ? Colors.white.withOpacity(0.06)
                          : const Color(0xFFFFB74D).withOpacity(0.2),

                      width: notif['isRead'] ? 1 : 1.5,
                    ),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ICON NOTIFIKASI
                      Container(
                        padding: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB74D).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Icon(
                          notif['icon'],
                          color: const Color(0xFFFFB74D),
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ISI NOTIFIKASI
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // JUDUL + INDIKATOR
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // TITIK NOTIFIKASI BELUM DIBACA
                                if (!notif['isRead'])
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 6,
                                      top: 5,
                                    ),
                                    width: 8,
                                    height: 8,

                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFB74D),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // PESAN
                            Text(
                              notif['message'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // WAKTU
                            Text(
                              notif['time'],
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.white24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
