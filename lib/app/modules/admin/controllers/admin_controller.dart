import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/auth_service.dart';

class AdminController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  // Navigation
  final currentNavIndex = 0.obs;

  // State
  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isLoadingStats = false.obs;
  final isLoadingProducts = false.obs;

  // Products
  final products = <Map<String, dynamic>>[].obs;
  final filteredProducts = <Map<String, dynamic>>[].obs;
  final searchProductQuery = ''.obs;

  // Stats
  final totalOrders = 0.obs;
  final totalRevenue = 0.0.obs;
  final pendingCount = 0.obs;
  final paidCount = 0.obs;
  final processingCount = 0.obs;
  final shippedCount = 0.obs;
  final deliveredCount = 0.obs;
  final cancelledCount = 0.obs;

  // Admin profile
  final adminName = ''.obs;
  final adminEmail = ''.obs;

  // Order filter
  final selectedStatusFilter = ''.obs;
  final filteredOrders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAdminData();
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }

  Future<void> loadAdminData() async {
    await Future.wait([
      loadDashboard(),
      loadProducts(),
      loadAdminProfile(),
    ]);
  }

  Future<void> loadAdminProfile() async {
    try {
      final user = await _authService.getUser();
      if (user != null) {
        adminName.value = user['name'] ?? 'Admin';
        adminEmail.value = user['email'] ?? '';
      }
    } catch (e) {
      print("Error loading admin profile: $e");
    }
  }

  Future<void> loadDashboard() async {
    await Future.wait([
      loadOrders(),
      loadStats(),
    ]);
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final data = await _apiService.getAdminOrders();
      orders.value = data.cast<Map<String, dynamic>>();
      _applyOrderFilter();
    } catch (e) {
      print("Error loading admin orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setStatusFilter(String status) {
    selectedStatusFilter.value = status;
    _applyOrderFilter();
  }

  void _applyOrderFilter() {
    if (selectedStatusFilter.value.isEmpty) {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders
          .where((o) => o['status'] == selectedStatusFilter.value)
          .toList();
    }
  }

  Future<void> loadStats() async {
    try {
      isLoadingStats.value = true;
      final stats = await _apiService.getOrderStats();

      totalOrders.value = stats['totalOrders'] ?? 0;
      totalRevenue.value = (stats['totalRevenue'] ?? 0).toDouble();

      final statusCount = stats['statusCount'] as Map<String, dynamic>? ?? {};
      pendingCount.value = (statusCount['pending'] ?? 0) as int;
      paidCount.value = (statusCount['paid'] ?? 0) as int;
      processingCount.value = (statusCount['processing'] ?? 0) as int;
      shippedCount.value = (statusCount['shipped'] ?? 0) as int;
      deliveredCount.value = (statusCount['delivered'] ?? 0) as int;
      cancelledCount.value = (statusCount['cancelled'] ?? 0) as int;
    } catch (e) {
      print("Error loading admin stats: $e");
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> loadProducts() async {
    try {
      isLoadingProducts.value = true;
      final data = await _apiService.getProducts();
      products.value = data.cast<Map<String, dynamic>>();
      _applyProductSearch();
    } catch (e) {
      print("Error loading products: $e");
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void setSearchProductQuery(String query) {
    searchProductQuery.value = query;
    _applyProductSearch();
  }

  void _applyProductSearch() {
    if (searchProductQuery.value.isEmpty) {
      filteredProducts.value = products;
    } else {
      final q = searchProductQuery.value.toLowerCase();
      filteredProducts.value = products
          .where((p) =>
              (p['name'] ?? '').toString().toLowerCase().contains(q) ||
              (p['category'] ?? '').toString().toLowerCase().contains(q))
          .toList();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _apiService.updateOrderStatus(orderId, newStatus);
      await loadDashboard();
      Get.snackbar(
        'Berhasil',
        'Status pesanan berhasil diperbarui',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: const Color(0xFFFFB74D),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.redAccent,
      );
    }
  }

  Future<void> verifyPayment(String orderId, String action, {String? rejectReason}) async {
    try {
      await _apiService.verifyPayment(orderId, action, rejectReason: rejectReason);
      await loadDashboard();
      Get.snackbar(
        'Berhasil',
        action == 'accept' ? 'Pembayaran diterima' : 'Pembayaran ditolak',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: const Color(0xFFFFB74D),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.redAccent,
      );
    }
  }

  // Product CRUD
  Future<void> createProduct({
    required String name,
    required String category,
    required double price,
    required String description,
    String image = '',
  }) async {
    try {
      await _apiService.createProduct(
        name: name,
        category: category,
        price: price,
        description: description,
        image: image,
      );
      await loadProducts();
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Produk berhasil ditambahkan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: const Color(0xFFFFB74D),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.redAccent,
      );
    }
  }

  Future<void> updateProduct(String id, {
    String? name,
    String? category,
    double? price,
    String? description,
    String? image,
  }) async {
    try {
      await _apiService.updateProduct(id,
        name: name,
        category: category,
        price: price,
        description: description,
        image: image,
      );
      await loadProducts();
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Produk berhasil diperbarui',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: const Color(0xFFFFB74D),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.redAccent,
      );
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _apiService.deleteProduct(id);
      await loadProducts();
      Get.snackbar(
        'Berhasil',
        'Produk berhasil dihapus',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: const Color(0xFFFFB74D),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.redAccent,
      );
    }
  }

  String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

