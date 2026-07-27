import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';

class NotifikasiController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final notifications = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Fetch notifikasi dari API
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final data = await _apiService.getNotifications();
      notifications.assignAll(data.cast<Map<String, dynamic>>());
    } catch (e) {
      // Jika gagal, tetap pakai data kosong
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Menandai notifikasi sebagai sudah dibaca
  Future<void> markAsRead(int index) async {
    if (index < 0 || index >= notifications.length) return;

    final notif = notifications[index];
    if (notif['isRead'] == true) return;

    // Optimistic update
    notif['isRead'] = true;
    notifications.refresh();

    try {
      await _apiService.markNotificationAsRead(notif['_id'] ?? '');
    } catch (e) {
      // Rollback jika gagal
      notif['isRead'] = false;
      notifications.refresh();
    }
  }

  // Menandai semua notifikasi sebagai sudah dibaca
  Future<void> markAllAsRead() async {
    try {
      await _apiService.markAllNotificationsAsRead();
      for (var notif in notifications) {
        notif['isRead'] = true;
      }
      notifications.refresh();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menandai semua notifikasi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: Colors.white,
      );
    }
  }

  // Menghapus satu notifikasi dari API
  Future<void> deleteNotification(int index) async {
    if (index < 0 || index >= notifications.length) return;

    final notif = notifications[index];
    final id = notif['_id'] ?? '';

    // Optimistic delete
    notifications.removeAt(index);

    try {
      await _apiService.deleteNotification(id);
    } catch (e) {
      // Rollback: tambahkan kembali
      notifications.insert(index, notif);
      Get.snackbar(
        'Error',
        'Gagal menghapus notifikasi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: Colors.white,
      );
    }
  }

  // Helper untuk format waktu relatif
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari yang lalu';
    return '${(diff.inDays / 7).floor()} minggu yang lalu';
  }

  // Helper untuk mendapatkan ikon berdasarkan tipe
  IconData getIconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_rounded;
      case 'promo':
        return Icons.discount_rounded;
      case 'system':
        return Icons.info_outline_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }
}
