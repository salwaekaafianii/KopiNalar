import 'package:get/get.dart';
import 'package:kopi_bnsp/app/data/models/cart_model.dart';
import 'package:kopi_bnsp/app/data/services/api_service.dart';
import 'package:kopi_bnsp/app/theme/snackbar_helper.dart';

class CartController extends GetxController {
  // Daftar item keranjang yang bersifat reaktif
  var cartItems = <CartItem>[].obs;
  final ApiService _apiService = ApiService();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  /// Load cart dari backend
  Future<void> loadCart() async {
    try {
      final response = await _apiService.getCart();
      if (response['cart'] != null && response['cart']['items'] != null) {
        final items = (response['cart']['items'] as List)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList();
        cartItems.value = items;
      }
    } catch (e) {
      // Jika gagal fetch, pakai data lokal atau kosong
      print("Gagal load cart: $e");
    }
  }

  /// Sync keranjang ke backend
  Future<void> syncCart() async {
    try {
      final items = cartItems.map((item) => item.toJson()).toList();
      await _apiService.syncCart(items);
    } catch (e) {
      print("Gagal sync cart: $e");
    }
  }

  /// Toggle pilih / tidak pilih item
  void toggleSelect(int index) {
    cartItems[index].isSelected = !cartItems[index].isSelected;
    cartItems.refresh();
    syncCart();
  }

  /// Menambah jumlah kuantitas
  void incrementQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
    syncCart();
  }

  /// Mengurangi jumlah kuantitas
  void decrementQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
    syncCart();
  }

  /// Menghapus item dari keranjang
  void removeItem(int index) {
    cartItems.removeAt(index);
    cartItems.refresh();
    syncCart();
  }

  int get totalItems {
    int total = 0;
    for (var item in cartItems) {
      total += item.quantity;
    }
    return total;
  }

  /// Hitung total harga ITEM YANG DIPILIH
  int get totalSelectedPrice {
    int total = 0;
    for (var item in cartItems) {
      if (item.isSelected) {
        total += (item.price * item.quantity);
      }
    }
    return total;
  }

  /// Jumlah item yang dipilih (untuk badge navbar)
  int get totalSelectedItems {
    int total = 0;
    for (var item in cartItems) {
      if (item.isSelected) {
        total++;
      }
    }
    return total;
  }

  int get totalCartItems {
    return cartItems.length;
  }

  /// Total semua item tanpa filter (untuk hitungan umum)
  int get totalPrice {
    int total = 0;
    for (var item in cartItems) {
      total += (item.price * item.quantity);
    }
    return total;
  }

  void addItem(Map<String, String> product) {
    final priceString =
        product['price']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0';
    final price = int.tryParse(priceString) ?? 0;

    final existingIndex = cartItems.indexWhere(
      (item) => item.name == product['name'],
    );
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: product['name']!,
          price: price > 0 ? price : 25000,
          imageUrl: product['image'] ?? '',
          productId: product['_id'] ?? product['id'] ?? '',
        ),
      );
    }

    syncCart();
    showCustomSnackbar(
      "Berhasil",
      "${product['name']} ditambahkan ke keranjang",
    );
  }
}
