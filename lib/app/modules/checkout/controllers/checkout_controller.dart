import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../alamat/controllers/alamat_controller.dart';
import '../../../theme/snackbar_helper.dart';

class CheckoutController extends GetxController {
  // ============================================================
  // ALAMAT CONTROLLER
  // ============================================================

  final AlamatController alamatController = Get.find<AlamatController>();

  // ============================================================
  // DATA DIRI
  // ============================================================

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  // ============================================================
  // ALAMAT PENGIRIMAN
  // ============================================================

  // TextField alamat di halaman checkout
  final addressController = TextEditingController();

  // Data koordinat
  final latitude = ''.obs;
  final longitude = ''.obs;

  // Data hasil alamat GPS / alamat tersimpan
  final gpsAddress = ''.obs;
  final gpsKecamatan = ''.obs;
  final gpsKota = ''.obs;
  final isDetectingLocation = false.obs;

  // ============================================================
  // TIPE ALAMAT YANG DIPILIH
  // ============================================================
  // gps   = menggunakan lokasi GPS
  // saved = menggunakan alamat tersimpan

  final selectedAddressType = ''.obs;

  // Menyimpan alamat tersimpan yang dipilih user
  final selectedSavedAddress = Rxn<Map<String, dynamic>>();

  // Apakah user sedang melihat daftar alamat tersimpan
  final isShowingSavedAddresses = false.obs;

  // ============================================================
  // METODE PEMBAYARAN
  // ============================================================

  final selectedPaymentMethod = RxString('Transfer Bank Mandiri');

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Transfer Bank Mandiri',
      'icon': Icons.account_balance_rounded,
      'desc': 'Pembayaran via transfer Bank Mandiri',
    },
    {
      'name': 'E-Wallet DANA',
      'icon': Icons.wallet_rounded,
      'desc': 'Pembayaran via DANA',
    },
    {
      'name': 'COD (Bayar di Tempat)',
      'icon': Icons.local_shipping_rounded,
      'desc': 'Bayar saat pesanan tiba',
    },
  ];

  // ============================================================
  // ORDER
  // ============================================================

  final orderItems = <Map<String, dynamic>>[].obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      // ----------------------------------------------------------
      // KASUS 1: DATA DARI KERANJANG (fromCart = true)
      // ----------------------------------------------------------
      if (args['fromCart'] == true && args['items'] != null) {
        final items = args['items'] as List<dynamic>;
        orderItems.assignAll(items.map((item) {
          final itemMap = item as Map<String, dynamic>;
          return {
            'image': itemMap['image'] ?? '',
            'name': itemMap['name'] ?? '',
            'variant': itemMap['variant'] ?? 'Regular, Normal, Sedikit',
            'price': itemMap['price'] ?? 0,
            'priceStr': itemMap['priceStr'] ?? '',
            'quantity': itemMap['quantity'] ?? 1,
          };
        }).toList());
      }
      // ----------------------------------------------------------
      // KASUS 2: DATA DARI "BELI SEKARANG" (product detail)
      // ----------------------------------------------------------
      else {
        final int qty = int.tryParse(args['quantity']?.toString() ?? '1') ?? 1;
        final int price =
            int.tryParse(
              args['productPrice']?.toString() ??
                  args['price']?.toString() ??
                  '0',
            ) ??
            0;

        orderItems.assignAll([
          {
            'image': args['productImage'] ?? '',
            'name': args['productName'] ?? '',
            'variant':
                '${args['ice'] ?? ''}, '
                '${args['sugar'] ?? ''}, '
                '${args['size'] ?? ''}',
            'price': price,
            'priceStr': formatRupiah(price),
            'quantity': qty,
          },
        ]);
      }
    }
  }

  // ============================================================
  // FORMAT RUPIAH
  // ============================================================

  String formatRupiah(num value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  // ============================================================
  // TOTAL PESANAN
  // ============================================================

  double get subtotal {
    return orderItems.fold(0, (sum, item) {
      final int price = int.tryParse(item['price']?.toString() ?? '0') ?? 0;

      final int quantity =
          int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

      return sum + (price * quantity);
    });
  }

  double get shippingCost => 10000;

  double get totalPayment => subtotal + shippingCost;

  // ============================================================
  // PILIH METODE PEMBAYARAN
  // ============================================================

  void changePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // ============================================================
  // PILIHAN 1: GUNAKAN GPS
  // ============================================================
  Future<void> detectLocation() async {
    // Cegah klik berkali-kali
    if (isDetectingLocation.value) return;

    try {
      isDetectingLocation.value = true;

      // Panggil GPS dari AlamatController
      await alamatController.detectLocation();

      // Cek apakah koordinat berhasil didapat
      if (alamatController.formLatController.text.isNotEmpty &&
          alamatController.formLngController.text.isNotEmpty) {
        latitude.value = alamatController.formLatController.text;
        longitude.value = alamatController.formLngController.text;

        gpsAddress.value = alamatController.formAddressController.text;

        gpsKecamatan.value = alamatController.kecamatan;

        gpsKota.value = alamatController.kota;

        selectedAddressType.value = 'gps';

        addressController.text = gpsAddress.value;

        showCustomSnackbar('Lokasi Dipilih', 'Lokasi GPS berhasil digunakan sebagai alamat pengiriman');
      }
    } catch (e) {
      showCustomSnackbar('Gagal', 'Gagal mendapatkan lokasi');
    } finally {
      // Apapun hasilnya, loading selesai
      isDetectingLocation.value = false;
    }
  }

  // ============================================================
  // PILIH ALAMAT TERSIMPAN
  // ============================================================

  void selectSavedAddress(Map<String, dynamic> alamat) {
    // Tandai alamat tersimpan
    selectedAddressType.value = 'saved';

    // Simpan alamat yang dipilih
    selectedSavedAddress.value = alamat;

    // Masukkan alamat ke TextField
    addressController.text = alamat['alamat']?.toString() ?? '';

    // Ambil koordinat
    latitude.value = alamat['lat']?.toString() ?? '';

    longitude.value = alamat['lng']?.toString() ?? '';

    // Simpan informasi alamat
    gpsAddress.value = alamat['alamat']?.toString() ?? '';

    gpsKecamatan.value = alamat['kecamatan']?.toString() ?? '';

    gpsKota.value = alamat['kota']?.toString() ?? '';

    showCustomSnackbar('Alamat Dipilih', 'Alamat tersimpan berhasil dipilih');
  }

  // ============================================================
  // AMBIL ALAMAT YANG SEDANG AKTIF
  // ============================================================

  Map<String, dynamic> getSelectedAddress() {
    // ----------------------------------------------------------
    // JIKA MENGGUNAKAN GPS
    // ----------------------------------------------------------

    if (selectedAddressType.value == 'gps') {
      return {
        'label': 'Lokasi GPS',
        'alamat': gpsAddress.value,
        'kecamatan': gpsKecamatan.value,
        'kota': gpsKota.value,
        'lat': latitude.value,
        'lng': longitude.value,
      };
    }

    // ----------------------------------------------------------
    // JIKA MENGGUNAKAN ALAMAT TERSIMPAN
    // ----------------------------------------------------------

    if (selectedAddressType.value == 'saved' &&
        selectedSavedAddress.value != null) {
      return selectedSavedAddress.value!;
    }

    // ----------------------------------------------------------
    // TIDAK ADA ALAMAT
    // ----------------------------------------------------------

    return {};
  }

  // ============================================================
  // BUAT PESANAN
  // ============================================================

  void makeOrder() {
    // ----------------------------------------------------------
    // VALIDASI NAMA
    // ----------------------------------------------------------

    if (nameController.text.trim().isEmpty) {
      showCustomSnackbar('Data Belum Lengkap', 'Silakan masukkan nama lengkap');
      return;
    }

    // ----------------------------------------------------------
    // VALIDASI NOMOR HP
    // ----------------------------------------------------------

    if (phoneController.text.trim().isEmpty) {
      showCustomSnackbar('Data Belum Lengkap', 'Silakan masukkan nomor HP');
      return;
    }

    // ----------------------------------------------------------
    // VALIDASI ALAMAT
    // ----------------------------------------------------------

    if (selectedAddressType.value.isEmpty) {
      showCustomSnackbar('Alamat Belum Dipilih', 'Silakan gunakan lokasi GPS atau pilih alamat tersimpan');
      return;
    }

    // Pastikan TextField alamat tidak kosong
    if (addressController.text.trim().isEmpty) {
      showCustomSnackbar('Alamat Tidak Valid', 'Alamat pengiriman belum tersedia');
      return;
    }

    // ----------------------------------------------------------
    // VALIDASI PESANAN
    // ----------------------------------------------------------

    if (orderItems.isEmpty) {
      showCustomSnackbar('Pesanan Kosong', 'Tidak ada produk yang dipesan');
      return;
    }

    // ----------------------------------------------------------
    // AMBIL ALAMAT AKTIF
    // ----------------------------------------------------------

    final alamat = getSelectedAddress();

    // ----------------------------------------------------------
    // PINDAH KE HALAMAN PAYMENT
    // ----------------------------------------------------------

    Get.toNamed(
      '/payment',
      arguments: {
        // ==========================
        // DATA PEMBAYARAN
        // ==========================
        'method': selectedPaymentMethod.value,

        'total': formatRupiah(totalPayment),

        // ==========================
        // DATA USER
        // ==========================
        'name': nameController.text.trim(),

        'phone': phoneController.text.trim(),

        // ==========================
        // DATA ALAMAT
        // ==========================
        'label': alamat['label'] ?? 'Lokasi GPS',

        'address': alamat['alamat'] ?? addressController.text.trim(),

        'kecamatan': alamat['kecamatan'] ?? '',

        'kota': alamat['kota'] ?? '',

        'latitude': alamat['lat'] ?? '',

        'longitude': alamat['lng'] ?? '',

        // ==========================
        // DATA PRODUK
        // ==========================
        'itemCount': orderItems.length,
        'items': orderItems.toList(),
        'productName': orderItems.first['name'],
        'productImage': orderItems.first['image'],
        'variant': orderItems.first['variant'],
        'quantity': orderItems.first['quantity'],
        'price': orderItems.first['price'],
      },
    );
  }

  void clearSelectedAddress() {
    selectedAddressType.value = '';

    addressController.clear();

    latitude.value = '';
    longitude.value = '';

    gpsAddress.value = '';
    gpsKecamatan.value = '';
    gpsKota.value = '';
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.onClose();
  }
}
