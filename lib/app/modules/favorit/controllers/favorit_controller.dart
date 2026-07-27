import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/auth_service.dart';

class FavoriteController extends GetxController {
  final favoriteItems = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// Load favorites dari backend
  Future<void> loadFavorites() async {
    // Jika guest, jangan fetch
    if (_authService.isGuest.value) {
      favoriteItems.clear();
      return;
    }

    try {
      isLoading.value = true;
      final data = await _apiService.getFavorites();
      favoriteItems.value = data.map<Map<String, dynamic>>((e) {
        return {
          'name': e['name']?.toString() ?? '',
          'category': e['category']?.toString() ?? '',
          'price': e['price']?.toString() ?? '',
          'rating': e['rating']?.toString() ?? '',
          'description': e['description']?.toString() ?? '',
          'image': e['image']?.toString() ?? '',
          'productId': e['productId']?.toString() ?? '',
          '_id': e['_id']?.toString() ?? '',
        };
      }).toList();
    } catch (e) {
      print("Gagal load favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Tambah favorite ke backend + local
  Future<void> addFavorite(Map<String, dynamic> product) async {
    // Cek duplikat lokal
    final exists = favoriteItems.any((item) => item['name'] == product['name']);
    if (exists) return;

    // Tambah ke lokal dulu biar UI cepat
    favoriteItems.add(Map<String, dynamic>.from(product));

    // Kirim ke backend (jika bukan guest)
    if (!_authService.isGuest.value) {
      try {
        await _apiService.addFavorite(
          name: product['name']?.toString() ?? '',
          category: product['category']?.toString() ?? '',
          price: product['price']?.toString() ?? '',
          rating: product['rating']?.toString() ?? '',
          description: product['description']?.toString() ?? '',
          image: product['image']?.toString() ?? '',
          productId: product['productId']?.toString() ?? product['_id']?.toString() ?? '',
        );
      } catch (e) {
        // Rollback lokal jika gagal
        favoriteItems.removeWhere((item) => item['name'] == product['name']);
        print("Gagal add favorite: $e");
      }
    }
  }

  /// Hapus favorite dari backend + local
  Future<void> removeFavorite(Map<String, dynamic> product) async {
    // Hapus dari lokal dulu
    favoriteItems.removeWhere((item) => item['name'] == product['name']);

    // Kirim ke backend (jika bukan guest)
    if (!_authService.isGuest.value) {
      try {
        await _apiService.removeFavorite(product['name']?.toString() ?? '');
      } catch (e) {
        print("Gagal remove favorite: $e");
      }
    }
  }

  /// Toggle favorite (async)
  Future<void> toggleFavorite(Map<String, dynamic> product) async {
    if (isFavorite(product)) {
      await removeFavorite(product);
    } else {
      await addFavorite(product);
    }
  }

  bool isFavorite(Map<String, dynamic> product) {
    return favoriteItems.any((item) => item['name'] == product['name']);
  }

  void goToDetail(Map<String, dynamic> product) {
    Get.toNamed('/product-detail', arguments: product);
  }
}
