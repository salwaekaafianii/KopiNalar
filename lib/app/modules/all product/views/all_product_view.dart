import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/all_product_controller.dart';

class AllProductsView extends GetView<AllProductsController> {
  const AllProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Menu',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          // Filter & Search Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
            ),
            child: Column(
              children: [
                // Search Bar + Tombol Filter
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: (value) =>
                            controller.searchQuery.value = value,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Cari semua menu...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white30,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white54,
                          ),
                          suffixIcon: Obx(
                            () => controller.searchQuery.value.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.white54,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      controller.searchController.clear();
                                      controller.searchQuery.value = '';
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFB74D),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Tombol Filter (Tune)
                    InkWell(
                      onTap: () => _showFilterBottomSheet(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildCategoryChip('Semua'),
                      const SizedBox(width: 10),
                      _buildCategoryChip('Panas'),
                      const SizedBox(width: 10),
                      _buildCategoryChip('Dingin'),
                      const SizedBox(width: 10),
                      _buildCategoryChip('Biji Kopi'),
                      const SizedBox(width: 10),
                      _buildCategoryChip('Pastry'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Grid Produk
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final list = controller.filteredProducts;

              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                        child: Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: const Color(0xFFFFB74D).withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Menu tidak ditemukan',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.73,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final product = list[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memunculkan Bottom Sheet Filter (Ikon Tune)
  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Atur Filter Menu',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            Text(
              'Urutkan Berdasarkan',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFFFFB74D),
              ),
              title: Text(
                'Terlaris',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
              onTap: () {
                controller.selectedSort.value = 'Terlaris';
                Get.back();
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.arrow_downward_rounded,
                color: Color(0xFFFFB74D),
              ),
              title: Text(
                'Termurah',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
              onTap: () {
                controller.selectedSort.value = 'Termurah';
                Get.back();
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.arrow_upward_rounded,
                color: Color(0xFFFFB74D),
              ),
              title: Text(
                'Termahal',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
              onTap: () {
                controller.selectedSort.value = 'Termahal';
                Get.back();
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.fiber_new_rounded,
                color: Color(0xFFFFB74D),
              ),
              title: Text(
                'Terbaru',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
              onTap: () {
                controller.selectedSort.value = 'Terbaru';
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Obx(() {
      bool isActive = controller.selectedCategory.value == label;
      return GestureDetector(
        onTap: () => controller.selectedCategory.value = label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFFFB74D)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.08),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isActive ? Colors.black : Colors.white70,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProductCard(Map<String, String> product) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => controller.goToDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //================ IMAGE =================
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    product['image']!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.white.withOpacity(0.05),
                        child: const Center(
                          child: Icon(
                            Icons.coffee,
                            color: Color(0xFFFFB74D),
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Favorite
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() {
                    final isFav = controller.isFavorite(product);

                    return GestureDetector(
                      onTap: () => controller.toggleFavorite(product),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.45),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : Colors.white,
                          size: 16,
                        ),
                      ),
                    );
                  }),
                ),

                // Rating
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Color(0xFFFFB74D),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product['rating'] ?? '0.0',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            //================ INFO =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      product['category']!,
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      controller.formatRupiah(product['price']!),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFFB74D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
