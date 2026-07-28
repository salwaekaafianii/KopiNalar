import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kopi_bnsp/app/data/services/api_service.dart';

class RiwayatController extends GetxController {
  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final data = await _apiService.getOrders();
      orders.assignAll(
        data.map((item) => item as Map<String, dynamic>).toList(),
      );
    } catch (e) {
      // Jika gagal, biarkan list kosong
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return '-';

    try {
      final cleanDate = dateStr.trim();
      print('>>> FORMAT DATE - Nilai createdAt mentah: "$cleanDate"');

      DateTime? parsedDate;

      // Coba parse sebagai ISO 8601 string
      try {
        parsedDate = DateTime.parse(cleanDate);
      } catch (_) {
        print('>>> DateTime.parse gagal untuk: "$cleanDate"');
      }

      // Jika gagal, coba parse sebagai Unix timestamp (milliseconds/detik)
      if (parsedDate == null) {
        final number = num.tryParse(cleanDate);
        if (number != null) {
          // Coba sebagai milliseconds (13 digit)
          if (number > 1000000000000) {
            parsedDate = DateTime.fromMillisecondsSinceEpoch(
              number.toInt(),
              isUtc: true,
            );
          } else {
            // Coba sebagai seconds (10 digit)
            parsedDate = DateTime.fromMillisecondsSinceEpoch(
              number.toInt() * 1000,
              isUtc: true,
            );
          }
          print('>>> Parsing sebagai Unix timestamp berhasil: $parsedDate');
        } else {
          print('>>> BUKAN ANGKA: "$cleanDate" bukan number');
        }
      }

      // Jika masih gagal, coba bersihkan string dari karakter 'Z'/timezone
      if (parsedDate == null) {
        // Hapus karakter Z di akhir jika ada
        String cleaned = cleanDate.replaceAll(RegExp(r'[Zz]$'), '');
        // Ganti spasi dengan T jika format "2024-01-01 00:00:00"
        cleaned = cleaned.replaceAll(' ', 'T');
        try {
          parsedDate = DateTime.parse(cleaned);
          print('>>> Parsing setelah cleaning berhasil: $parsedDate');
        } catch (_) {
          print('>>> Parsing setelah cleaning GAGAL untuk: "$cleaned"');
        }
      }

      if (parsedDate == null) {
        print('>>> GAGAL TOTAL - Tidak bisa parse tanggal: "$cleanDate"');
        return 'Tanggal tidak valid';
      }

      // Ubah ke zona waktu WIB (UTC+7) secara eksplisit
      final wibDate = parsedDate.add(Duration(hours: 7));

      return '${DateFormat('dd MMM yyyy, HH:mm', 'en_US').format(wibDate)} WIB';
    } catch (e) {
      print('>>> EXCEPTION di formatDate: $e');
      print('>>> Stack trace: ${StackTrace.current}');
      return 'Tanggal tidak valid';
    }
  }

  String getInvoiceNumber(Map<String, dynamic> order) {
    // Format: #KPN + 6 digit akhir ObjectId
    final id = order['_id']?.toString() ?? '';
    final idSuffix = id.length >= 6
        ? id.substring(id.length - 6).toUpperCase()
        : id;
    return '#KPN-$idSuffix';
  }

  String getStatusLabel(String? status, String? paymentStatus) {
    // Pesanan dibatalkan, baik karena bukti ditolak
    // maupun karena melewati batas waktu 2 hari
    if (status == 'cancelled') {
      if (paymentStatus == 'rejected') {
        return 'Pembayaran Ditolak';
      }

      return 'Dibatalkan Otomatis';
    }

    // Pembayaran transfer sedang dicek admin
    if (paymentStatus == 'waiting_verification') {
      return 'Menunggu Verifikasi';
    }

    // Bukti pembayaran ditolak admin
    if (paymentStatus == 'rejected') {
      return 'Pembayaran Ditolak';
    }

    // Pembayaran sudah diverifikasi admin
    if (paymentStatus == 'verified' && status == 'pending') {
      return 'Pembayaran Berhasil';
    }

    // Status proses pesanan
    switch (status) {
      case 'processing':
        return 'Sedang Diproses';

      case 'shipped':
        return 'Sedang Dikirim';

      case 'delivered':
        return 'Selesai';

      case 'pending':
        return 'Menunggu Pembayaran';

      default:
        return 'Menunggu';
    }
  }

  Color getStatusColor(String? status, String? paymentStatus) {
    // Pesanan dibatalkan
    if (status == 'cancelled') {
      return Colors.red;
    }

    // Bukti pembayaran ditolak
    if (paymentStatus == 'rejected') {
      return Colors.red;
    }

    // Menunggu admin mengecek bukti
    if (paymentStatus == 'waiting_verification') {
      return Colors.orange;
    }

    // Pembayaran sudah dikonfirmasi
    if (paymentStatus == 'verified' && status == 'pending') {
      return Colors.blue;
    }

    switch (status) {
      case 'processing':
        return Colors.blue;

      case 'shipped':
        return Colors.purple;

      case 'delivered':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  String getFormatRupiah(dynamic amount) {
    if (amount == null) return 'Rp 0';
    final numValue = num.tryParse(amount.toString()) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(numValue);
  }
}
