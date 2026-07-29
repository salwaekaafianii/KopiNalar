import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/api_service.dart';
import '../controllers/admin_controller.dart';

class ProductsView extends GetView<AdminController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              'Kelola Produk',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddProductDialog(context),
            icon: const Icon(Icons.add_rounded, color: Color(0xFFFFB74D)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => controller.setSearchProductQuery(value),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white30,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white38,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.03),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFFB74D)),
                ),
              ),
            ),
          ),

          // Product list
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFFFFB74D),
              backgroundColor: const Color(0xFF1A1A1A),
              onRefresh: () async {
                await controller.loadProducts();
              },
              child: Obx(() {
                if (controller.isLoadingProducts.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  );
                }

                if (controller.filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.coffee_rounded,
                          size: 60,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada produk',
                          style: GoogleFonts.poppins(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap ikon + untuk menambah produk',
                          style: GoogleFonts.poppins(
                            color: Colors.white24,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return _buildProductCard(context, product);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final id = product['_id']?.toString() ?? '';
    final name = product['name']?.toString() ?? '';
    final category = product['category']?.toString() ?? '';
    final price = (product['price'] ?? 0).toDouble();
    final image = product['image']?.toString() ?? '';
    final description = product['description']?.toString() ?? '';
    final rating = (product['rating'] ?? 0).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.white.withOpacity(0.05),
                        child: const Icon(
                          Icons.coffee_rounded,
                          color: Colors.white24,
                          size: 30,
                        ),
                      ),
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: Colors.white.withOpacity(0.05),
                      child: const Icon(
                        Icons.coffee_rounded,
                        color: Colors.white24,
                        size: 30,
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFFB74D),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFFB74D),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        controller.formatRupiah(price),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _showEditProductDialog(context, product),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.withOpacity(0.25)),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _confirmDeleteProduct(context, id, name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.withOpacity(0.25)),
                    ),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    var selectedImagePath = ''.obs;
    var selectedImageBytes = Rx<Uint8List?>(null);

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Tambah Produk',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(
                nameController,
                'Nama Produk',
                hint: 'Contoh: Kopi Arabika',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                categoryController,
                'Kategori',
                hint: 'Contoh: Kopi Bubuk',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                priceController,
                'Harga',
                hint: 'Contoh: 25000',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                descriptionController,
                'Deskripsi',
                hint: 'Deskripsi produk',
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Image picker
              Obx(() {
                return GestureDetector(
                  onTap: () => _pickImage((bytes, path) {
                    selectedImageBytes.value = bytes;
                    selectedImagePath.value = path ?? '';
                  }),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: selectedImageBytes.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              selectedImageBytes.value!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_rounded,
                                color: Colors.white38,
                                size: 32,
                              ),
                              SizedBox(height: 4),
                              Text('Tap untuk upload gambar'),
                            ],
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final category = categoryController.text.trim();
              final price = double.tryParse(priceController.text.trim()) ?? 0;
              final description = descriptionController.text.trim();

              if (name.isEmpty ||
                  category.isEmpty ||
                  price <= 0 ||
                  description.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Semua field harus diisi dengan benar',
                  backgroundColor: const Color(0xFF1A1A1A),
                  colorText: Colors.redAccent,
                );
                return;
              }

              String imageUrl = '';
              if (selectedImageBytes.value != null) {
                try {
                  imageUrl = await controller.uploadImage(
                    selectedImageBytes.value!,
                    selectedImagePath.value,
                  );
                } catch (e) {
                  // Skip image if upload fails
                }
              }

              await controller.createProduct(
                name: name,
                category: category,
                price: price,
                description: description,
                image: imageUrl,
              );
            },
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFFB74D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    final id = product['_id']?.toString() ?? '';
    final nameController = TextEditingController(
      text: product['name']?.toString() ?? '',
    );
    final categoryController = TextEditingController(
      text: product['category']?.toString() ?? '',
    );
    final priceController = TextEditingController(
      text: (product['price'] ?? 0).toString(),
    );
    final descriptionController = TextEditingController(
      text: product['description']?.toString() ?? '',
    );
    var selectedImageBytes = Rx<Uint8List?>(null);
    var selectedImagePath = ''.obs;
    final currentImage = product['image']?.toString() ?? '';

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit Produk',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(nameController, 'Nama Produk'),
              const SizedBox(height: 12),
              _buildDialogTextField(categoryController, 'Kategori'),
              const SizedBox(height: 12),
              _buildDialogTextField(
                priceController,
                'Harga',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                descriptionController,
                'Deskripsi',
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              Obx(() {
                return GestureDetector(
                  onTap: () => _pickImage((bytes, path) {
                    selectedImageBytes.value = bytes;
                    selectedImagePath.value = path ?? '';
                  }),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: selectedImageBytes.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              selectedImageBytes.value!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : currentImage.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              currentImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.image_rounded,
                                    color: Colors.white38,
                                    size: 32,
                                  ),
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_rounded,
                                color: Colors.white38,
                                size: 32,
                              ),
                              SizedBox(height: 4),
                              Text('Tap untuk ganti gambar'),
                            ],
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              String imageUrl = currentImage;
              if (selectedImageBytes.value != null) {
                try {
                  imageUrl = await controller.uploadImage(
                    selectedImageBytes.value!,
                    selectedImagePath.value,
                  );
                } catch (e) {
                  // keep old image
                }
              }

              await controller.updateProduct(
                id,
                name: nameController.text.trim(),
                category: categoryController.text.trim(),
                price: double.tryParse(priceController.text.trim()),
                description: descriptionController.text.trim(),
                image: imageUrl,
              );
            },
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFFB74D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteProduct(BuildContext context, String id, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hapus Produk',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "$name"?',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteProduct(id);
            },
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(
    TextEditingController controller,
    String label, {
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFFB74D)),
        ),
      ),
    );
  }

  Future<void> _pickImage(Function(Uint8List, String?) onPicked) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        onPicked(bytes, image.name);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: $e',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.redAccent,
      );
    }
  }
}

extension AdminControllerUpload on AdminController {
  Future<String> uploadImage(Uint8List bytes, String filename) async {
    final apiService = Get.find<ApiService>();
    return await apiService.uploadImage(bytes, filename);
  }
}
