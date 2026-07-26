import 'package:get/get.dart';

class BantuanController extends GetxController {
  final faqs = <Map<String, dynamic>>[
    {
      'question': 'Bagaimana cara melakukan pemesanan?',
      'answer': 'Pilih produk yang Anda inginkan, tambahkan ke keranjang, lalu lanjutkan ke checkout. Isi data diri dan alamat, pilih metode pembayaran, dan konfirmasi pesanan.',
      'isExpanded': false,
    },
    {
      'question': 'Metode pembayaran apa saja yang tersedia?',
      'answer': 'Kami menerima pembayaran melalui Transfer Bank Mandiri, E-Wallet DANA, dan COD (Bayar di Tempat).',
      'isExpanded': false,
    },
    {
      'question': 'Berapa lama waktu pengiriman?',
      'answer': 'Estimasi pengiriman sekitar 30-60 menit tergantung lokasi Anda. Untuk area terjangkau, pengiriman bisa lebih cepat.',
      'isExpanded': false,
    },
    {
      'question': 'Bagaimana cara melacak pesanan?',
      'answer': 'Anda dapat melihat status pesanan di halaman Riwayat Pesanan. Status akan diperbarui secara real-time.',
      'isExpanded': false,
    },
    {
      'question': 'Apakah bisa membatalkan pesanan?',
      'answer': 'Pesanan dapat dibatalkan selama status masih "Diproses". Hubungi customer service kami untuk pembatalan.',
      'isExpanded': false,
    },
  ].obs;

  void toggleFaq(int index) {
    faqs[index]['isExpanded'] = !(faqs[index]['isExpanded'] as bool);
    faqs.refresh();
  }
}

