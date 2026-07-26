import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifikasiController extends GetxController {
  // Daftar notifikasi
  final notifications = <Map<String, dynamic>>[
    {
      'icon': Icons.check_circle_rounded,
      'title': 'Pesanan Berhasil',
      'message': 'Pesanan Caffe Latte Anda telah berhasil dibuat.',
      'time': '2 menit yang lalu',
      'isRead': false,
    },
    {
      'icon': Icons.local_shipping_rounded,
      'title': 'Pesanan Dikirim',
      'message':
          'Pesanan Anda sedang dalam perjalanan. Estimasi tiba 15 menit lagi.',
      'time': '1 jam yang lalu',
      'isRead': false,
    },
    {
      'icon': Icons.discount_rounded,
      'title': 'Promo Spesial!',
      'message':
          'Dapatkan diskon 20% untuk pembelian kopi kedua.',
      'time': '3 jam yang lalu',
      'isRead': true,
    },
    {
      'icon': Icons.star_rounded,
      'title': 'Produk Baru',
      'message':
          'Nalar Blend edisi terbatas sudah tersedia!',
      'time': '1 hari yang lalu',
      'isRead': true,
    },
  ].obs;

  // Menandai notifikasi sebagai sudah dibaca
  void markAsRead(int index) {
    notifications[index]['isRead'] = true;
    notifications.refresh();
  }

  // Menghapus satu notifikasi
  void deleteNotification(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);
    }
  }
}