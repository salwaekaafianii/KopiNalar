import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../favorit/controllers/favorit_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../theme/snackbar_helper.dart';

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ApiService apiService = Get.find<ApiService>();
  final AuthService authService = Get.find<AuthService>();
  var isLoading = false.obs;
  var userName = ''.obs; // Nama depan user yang login
  // Reactive variables untuk sort & search
  final selectedSort = RxString('Terlaris');
  final searchQuery = RxString('');
  var allProducts = <Map<String, String>>[].obs;
  final unreadNotificationCount = 0.obs;
  Future<void> loadUnreadNotificationCount() async {
    try {
      final notifications = await apiService.getNotifications();

      unreadNotificationCount.value = notifications.where((e) {
        return e['isRead'] == false;
      }).length;
    } catch (e) {
      unreadNotificationCount.value = 0;
    }
  }

  /// Load nama user dari storage
  Future<void> loadUserName() async {
    final name = await authService.getFirstName();
    userName.value = name;
  }

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

      print("Jumlah produk: ${allProducts.length}");
      print(allProducts.first);
    } catch (e) {
      showCustomSnackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Getter untuk memfilter produk berdasarkan pencarian dan sorting
  List<Map<String, String>> get filteredProducts {
    var result = allProducts.where((product) {
      return product['name']!.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );
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
          return product['name']!.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
        }).toList();
        break;
    }

    return result;
  }

  int _parsePrice(String price) {
    String cleaned = price
        .replaceAll('Rp', '')
        .replaceAll('rb', '')
        .replaceAll('.', '')
        .trim();
    if (price.contains('rb')) {
      return (int.tryParse(cleaned) ?? 0) * 1000;
    }
    return int.tryParse(cleaned) ?? 0;
  }

  FavoriteController get _favoriteController => Get.find<FavoriteController>();

  Future<void> toggleFavorite(Map<String, dynamic> product) async {
    await _favoriteController.toggleFavorite(product);
  }

  bool isFavorite(Map<String, dynamic> product) {
    return _favoriteController.isFavorite(product);
  }

  // Fungsi untuk memasukkan produk ke keranjang
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

  // Fungsi saat ikon keranjang di navbar atas diklik
  void goToCart() {
    Get.toNamed('/cart');
  }

  // Fungsi saat ikon notifikasi diklik
  void goToNotifications() {
    // Blokir tamu: harus login dulu sebelum mengakses notifikasi
    if (authService.requireLogin('notifikasi')) {
      return;
    }

    Get.toNamed('/notifikasi');
  }

  void goToDetail(Map<String, String> product) {
    Get.toNamed('/product-detail', arguments: product);
  }

  @override
  void onInit() {
    super.onInit();
    loadUserName();
    loadUnreadNotificationCount();
    getProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
