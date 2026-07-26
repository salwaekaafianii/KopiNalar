import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/services/auth_service.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: Text(
          'Keranjang Pesanan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF121212),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1),
        ),
      ),

      body: Obx(() {
        final authService = Get.find<AuthService>();

        // =========================
        // GUEST - tampilkan pesan login
        // =========================
        if (authService.isGuest.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Login untuk Melihat Keranjang',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masuk ke akunmu untuk mulai berbelanja',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // =========================
        // KERANJANG KOSONG
        // =========================
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 50,
                    color: const Color(0xFFFFB74D).withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Wah, Keranjangmu Masih Kosong',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Yuk, temukan kopi favoritmu dan\nisi keranjang sekarang!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white54,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: 200,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final mainController = Get.find<MainController>();
                      mainController.changeIndex(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Belanja Sekarang',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // =========================
        // ADA ISI KERANJANG
        // =========================
        return Column(
          children: [
            // =========================
            // DAFTAR PRODUK
            // =========================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 20,
                ),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      children: [
                        // CHECKBOX PILIH
                        GestureDetector(
                          onTap: () => controller.toggleSelect(index),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: item.isSelected
                                  ? const Color(0xFFFFB74D)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: item.isSelected
                                    ? const Color(0xFFFFB74D)
                                    : Colors.white38,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              item.isSelected
                                  ? Icons.check
                                  : Icons.check_box_outline_blank,
                              size: 16,
                              color: item.isSelected
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                        ),

                        // FOTO PRODUK
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imageUrl,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFFB74D,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.coffee,
                                  color: Color(0xFFFFB74D),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 14),

                        // INFORMASI PRODUK
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                formatRupiah(item.price),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFFFFB74D),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // QUANTITY
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        controller.decrementQuantity(index),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.06),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Text(
                                      '${item.quantity}',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () =>
                                        controller.incrementQuantity(index),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.06),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // HAPUS
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: 22,
                          ),
                          onPressed: () => controller.removeItem(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // =========================
            // RINGKASAN PESANAN (hanya muncul jika ada item dipilih)
            // =========================
            Obx(() {
              if (controller.totalSelectedItems == 0) {
                return const SizedBox.shrink();
              }
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.08)),
                  ),
                ),
                child: Column(
                  children: [
                    // SUBTOTAL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal (${controller.totalSelectedItems} item)',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          formatRupiah(controller.totalSelectedPrice),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // BIAYA PENGIRIMAN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Biaya Pengiriman',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          'Rp 10.000',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Divider(color: Colors.white12),

                    const SizedBox(height: 12),

                    // TOTAL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          formatRupiah(controller.totalSelectedPrice + 10000),
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFB74D),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // Kirim data item yang dipilih ke halaman checkout
                          final selectedItems = controller.cartItems
                              .where((item) => item.isSelected)
                              .map((item) => {
                                    'image': item.imageUrl,
                                    'name': item.name,
                                    'price': item.price,
                                    'priceStr': formatRupiah(item.price),
                                    'quantity': item.quantity,
                                    'variant': 'Regular, Normal, Sedikit',
                                  })
                              .toList();

                          Get.toNamed('/checkout', arguments: {
                            'fromCart': true,
                            'items': selectedItems,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB74D),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Pesan Sekarang',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
