import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kopi_bnsp/app/theme/button_styles.dart';
import '../controllers/product_detail_controller.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              // Tombol Bagikan
              IconButton(
                onPressed: () async {
                  await Share.share(
                    'Yuk coba ${controller.productName}! '
                    '${controller.productDescription}\n'
                    'Harga: ${controller.formatRupiah(controller.productPrice)}',
                    subject: 'Rekomendasi Produk Kopi',
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              // Tombol Favorit
              Obx(() {
                final isFav = controller.isFavorite.value;

                return IconButton(
                  onPressed: () => controller.toggleFavorite(),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.redAccent : Colors.white,
                      size: 18,
                    ),
                  ),
                );
              }),

              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    controller.productImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white10,
                      child: const Icon(
                        Icons.coffee,
                        size: 80,
                        color: Color(0xFFFFB74D),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF121212).withOpacity(0.8),
                          const Color(0xFF121212),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(color: Colors.white.withOpacity(0.08), height: 1),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildBadge('Best Seller', const Color(0xFFFFB74D)),
                      const SizedBox(width: 8),
                      _buildBadge(controller.productCategory, Colors.white24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.productName,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        controller.formatRupiah(controller.productPrice),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFB74D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.productDescription,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB74D),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.productRating,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(120+ Ulasan)',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.white12),
                  ),

                  Text(
                    'Pilih Ukuran',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: _buildSelectCard(
                            title: 'Regular',
                            subtitle: '350ml',
                            isSelected:
                                controller.selectedSize.value == 'Regular',
                            onTap: () => controller.selectSize('Regular'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSelectCard(
                            title: 'Large',
                            subtitle: '+Rp 5.000',
                            isSelected:
                                controller.selectedSize.value == 'Large',
                            onTap: () => controller.selectSize('Large'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Tingkat Gula',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      children: [
                        _buildChipOption(
                          'Kurang',
                          controller.selectedSugar,
                          controller.selectSugar,
                        ),
                        const SizedBox(width: 8),
                        _buildChipOption(
                          'Normal',
                          controller.selectedSugar,
                          controller.selectSugar,
                        ),
                        const SizedBox(width: 8),
                        _buildChipOption(
                          'Ekstra',
                          controller.selectedSugar,
                          controller.selectSugar,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Pilihan Es',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: _buildSelectCard(
                            title: 'Sedikit',
                            subtitle: 'Es lebih cepat cair',
                            isSelected:
                                controller.selectedIce.value == 'Sedikit',
                            onTap: () => controller.selectIce('Sedikit'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSelectCard(
                            title: 'Banyak',
                            subtitle: 'Dingin lebih lama',
                            isSelected:
                                controller.selectedIce.value == 'Banyak',
                            onTap: () => controller.selectIce('Banyak'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jumlah Pesanan',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: controller.decrement,
                              icon: const Icon(
                                Icons.remove,
                                size: 16,
                                color: Colors.white70,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.06),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Obx(
                                () => Text(
                                  '${controller.quantity.value}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: controller.increment,
                              icon: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white70,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.06),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
        ),
        child: Row(
          children: [
            // Tombol Tambah ke Keranjang
            SizedBox(
              height: 50,
              width: 60,
              child: OutlinedButton(
                onPressed: () => controller.addToCart(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFB74D),
                  side: const BorderSide(color: Color(0xFFFFB74D)),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.shopping_cart_outlined, size: 22),
              ),
            ),

            const SizedBox(width: 12),

            // Tombol Beli Sekarang
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: kSecondaryButton(),
                  onPressed: () {
                    // Langsung menuju halaman pemesanan
                    controller.buyNow();
                  },
                  child: Text(
                    'Beli Sekarang',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(bgColor == Colors.white24 ? 0.1 : 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: bgColor == Colors.white24 ? Colors.white70 : bgColor,
        ),
      ),
    );
  }

  Widget _buildSelectCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFB74D).withOpacity(0.1)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFB74D)
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.coffee_outlined,
                  size: 20,
                  color: Color(0xFFFFB74D),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Color(0xFFFFB74D),
                  )
                else
                  const Icon(
                    Icons.circle_outlined,
                    size: 16,
                    color: Colors.white24,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipOption(
    String label,
    RxString selectedGroup,
    Function(String) onTap,
  ) {
    bool isSelected = selectedGroup.value == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFB74D).withOpacity(0.1)
                : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFFB74D)
                  : Colors.white.withOpacity(0.08),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFFFFB74D) : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
