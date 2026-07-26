import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../favorit/controllers/favorit_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/services/api_service.dart';
import '../../../theme/snackbar_helper.dart';
import 'package:intl/intl.dart';

class AllProductsController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;

  var allProducts = <Map<String, String>>[].obs;

  // State untuk pencarian di halaman All Products
  final searchQuery = RxString('');
  final selectedCategory = RxString('Semua');
  final selectedSort = RxString('Terlaris');
  final searchController = TextEditingController();

  FavoriteController get _favoriteController => Get.find<FavoriteController>();
  String formatRupiah(String price) {
    final number = int.tryParse(price) ?? 0;

    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  // Contoh data dummy produk (bisa disesuaikan dengan data di HomeController kamu)
  Future<void> getProducts() async {
    try {
      isLoading.value = true;

      final data = await apiService.getProducts();

      allProducts.value = data.map<Map<String, String>>((e) {
        return {
          "name": e["name"].toString(),
          "category": e["category"].toString(),
          "price": e["price"].toString(),
          "rating": e["rating"].toString(),
          "description": e["description"].toString(),
          "image": e["image"].toString(),
        };
      }).toList();
    } catch (e) {
      showCustomSnackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // List yang sudah difilter berdasarkan Kategori & Search Query
  List<Map<String, String>> get filteredProducts {
    var result = allProducts.where((product) {
      final matchesCategory =
          selectedCategory.value == 'Semua' ||
          product['category'] == selectedCategory.value;
      final matchesSearch = product['name']!.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    switch (selectedSort.value) {
      case 'Terlaris':
        result.sort(
          (a, b) => (b['rating'] ?? '0.0').compareTo(a['rating'] ?? '0.0'),
        );
        break;
      case 'Termurah':
        result.sort((a, b) {
          int priceA = _parsePrice(a['price'] ?? '0');
          int priceB = _parsePrice(b['price'] ?? '0');
          return priceA.compareTo(priceB);
        });
        break;
      case 'Termahal':
        result.sort((a, b) {
          int priceA = _parsePrice(a['price'] ?? '0');
          int priceB = _parsePrice(b['price'] ?? '0');
          return priceB.compareTo(priceA);
        });
        break;
      case 'Terbaru':
        result = allProducts.where((product) {
          final matchesCategory =
              selectedCategory.value == 'Semua' ||
              product['category'] == selectedCategory.value;
          final matchesSearch = product['name']!.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
          return matchesCategory && matchesSearch;
        }).toList();
        break;
    }

    return result;
  }

  int _parsePrice(String price) {
    return int.tryParse(price) ?? 0;
  }

  void toggleFavorite(Map<String, dynamic> product) {
    _favoriteController.toggleFavorite(product);
  }

  bool isFavorite(Map<String, dynamic> product) {
    return _favoriteController.isFavorite(product);
  }

  void addToCart(String productName) {
    // Cari data produk lengkap berdasarkan nama
    final product = allProducts.firstWhere(
      (p) => p['name'] == productName,
      orElse: () => {
        'name': productName,
        'price': '0',
        'image': '',
        'rating': '0.0',
        'category': '',
      },
    );
    // Kirim data produk lengkap ke CartController
    Get.find<CartController>().addItem(product);
  }

  void goToDetail(Map<String, String> product) {
    Get.toNamed('/product-detail', arguments: product);
  }

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
