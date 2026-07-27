import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kopi_bnsp/app/data/services/api_service.dart';
import 'package:kopi_bnsp/app/theme/snackbar_helper.dart';

class PaymentController extends GetxController {
  late String paymentMethodName;
  late String totalPayment;
  late IconData paymentIcon;

  final ImagePicker _picker = ImagePicker();

  // BYTES GAMBAR - SATU-SATUNYA SOURCE OF TRUTH UNTUK DITAMPILKAN
  final Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);

  // LOADING STATE
  final RxBool isLoadingImage = false.obs;

  // PATH GAMBAR (untuk dikirim ke argument)
  final RxString imagePath = ''.obs;

  // DATA PESANAN DARI CHECKOUT
  Map<String, dynamic>? _orderArgs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};

    _orderArgs = args;

    paymentMethodName = args['method']?.toString() ?? 'Transfer Bank Mandiri';

    totalPayment = args['total']?.toString() ?? 'Rp 0';

    switch (paymentMethodName) {
      case 'Transfer Bank Mandiri':
        paymentIcon = Icons.account_balance_rounded;
        break;

      case 'E-Wallet DANA':
        paymentIcon = Icons.wallet_rounded;
        break;

      case 'COD (Bayar di Tempat)':
        paymentIcon = Icons.local_shipping_rounded;
        break;

      default:
        paymentIcon = Icons.payment_rounded;
    }
  }

  // =====================================================
  // PILIH GAMBAR
  // =====================================================

  Future<void> pickImage() async {
    try {
      isLoadingImage.value = true;

      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedImage == null) {
        print('User membatalkan pilih gambar');
        isLoadingImage.value = false;
        return;
      }

      print('Gambar dipilih: ${pickedImage.path}');
      print('File name: ${pickedImage.name}');
      print('Mime type: ${pickedImage.mimeType}');

      // BACA BYTES LANGSUNG DARI XFile (handle content:// URI)
      final bytes = await pickedImage.readAsBytes();
      print('Gambar berhasil dibaca: ${bytes.length} bytes');

      // SET BYTES - INI YANG AKAN DI-TAMPILKAN DI Image.memory
      imageBytes.value = bytes;

      // SIMPAN PATH UNTUK ARGUMENT
      imagePath.value = pickedImage.path;

      isLoadingImage.value = false;

      print('SETELAH PICK - imageBytes: ${imageBytes.value?.length} bytes');
      print('SETELAH PICK - imagePath: ${imagePath.value}');
    } catch (e, stackTrace) {
      print('ERROR PICK IMAGE: $e');
      print(stackTrace);

      isLoadingImage.value = false;

      showCustomSnackbar('Gagal', 'Gagal memilih gambar');
    }
  }

  // =====================================================
  // HAPUS GAMBAR
  // =====================================================

  void removeImage() {
    imageBytes.value = null;
    imagePath.value = '';
  }

  // =====================================================
  // APAKAH PUNYA GAMBAR?
  // =====================================================

  bool get hasImage => imageBytes.value != null;

  // =====================================================
  // KONFIRMASI
  // =====================================================

  final isSubmitting = false.obs;

  Future<void> confirmPayment() async {
    if (paymentMethodName != 'COD (Bayar di Tempat)' &&
        imageBytes.value == null) {
      showCustomSnackbar("Bukti Belum Ada", "Silakan upload bukti pembayaran");
      return;
    }

    isSubmitting.value = true;

    // Simpan pesanan ke backend
    try {
      final ApiService _apiService = Get.find<ApiService>();

      // Konversi items dari _orderArgs
      final List<Map<String, dynamic>> items = [];
      if (_orderArgs != null && _orderArgs!['items'] != null) {
        for (var item in (_orderArgs!['items'] as List)) {
          items.add({
            'name': item['name'] ?? '',
            'price': item['price'] ?? 0,
            'quantity': item['quantity'] ?? 1,
            'variant': item['variant'] ?? '',
            'image': item['image'] ?? '',
          });
        }
      }

      // Parse totalPayment dari string "Rp ..." ke angka
      final totalStr = totalPayment.replaceAll(RegExp(r'[^0-9]'), '');
      final totalNumeric = double.tryParse(totalStr) ?? 0.0;

      // Status: Semua pembayaran jadi "pending" dulu menunggu konfirmasi admin
      // COD juga pending sampai admin konfirmasi
      await _apiService.createOrder(
        items: items,
        totalPayment: totalNumeric,
        shippingCost: 10000,
        paymentMethod: paymentMethodName,
        status: 'pending',
        customer: {
          'name': _orderArgs?['name'] ?? '',
          'phone': _orderArgs?['phone'] ?? '',
        },
        address: {
          'label': _orderArgs?['label'] ?? '',
          'alamat': _orderArgs?['address'] ?? '',
          'kecamatan': _orderArgs?['kecamatan'] ?? '',
          'kota': _orderArgs?['kota'] ?? '',
          'lat': _orderArgs?['latitude'] ?? '',
          'lng': _orderArgs?['longitude'] ?? '',
        },
      );

      // Hapus keranjang setelah pesanan berhasil dibuat
      try {
        await _apiService.clearCart();
      } catch (_) {
        // Abaikan jika gagal clear cart
      }

      isSubmitting.value = false;

      Get.offNamed(
        '/payment-success',
        arguments: {'method': paymentMethodName, 'total': totalPayment},
      );
    } catch (e) {
      isSubmitting.value = false;
      showCustomSnackbar('Gagal', 'Gagal menyimpan pesanan: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }
}
