import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../favorit/controllers/favorit_controller.dart';
import '../../../theme/snackbar_helper.dart';

class ProductDetailController extends GetxController {
  final quantity = 1.obs;
  final selectedSize = 'Regular'.obs;
  final selectedSugar = 'Normal'.obs;
  final selectedIce = 'Sedikit'.obs;
  final isFavorite = false.obs;

  // =========================
  // DATA PRODUK
  // =========================

  late String productName;
  late String productImage;
  late String productPrice;
  late String productRating;
  late String productDescription;
  late String productCategory;

  @override
  void onInit() {
    super.onInit();

    // Jangan gunakan Map<String, String>
    // karena arguments memiliki tipe data yang berbeda
    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      productName = args['name']?.toString() ??
          args['productName']?.toString() ??
          'Produk';

      productImage = args['image']?.toString() ??
          args['productImage']?.toString() ??
          '';

      productPrice = args['price']?.toString() ??
          args['productPrice']?.toString() ??
          '0';

      productRating = args['rating']?.toString() ?? '0.0';

      productDescription =
          args['description']?.toString() ?? '';

      productCategory =
          args['category']?.toString() ?? '';
    } else {
      productName = 'Produk';
      productImage = '';
      productPrice = '0';
      productRating = '0.0';
      productDescription = '';
      productCategory = '';
    }

    // Cek apakah produk sudah menjadi favorit
    final favoriteController = Get.find<FavoriteController>();

    isFavorite.value =
        favoriteController.isFavorite(productAsMap);
  }

  // =========================
  // FORMAT RUPIAH
  // =========================

  String formatRupiah(String price) {
    final number = int.tryParse(
          price.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  // =========================
  // QUANTITY
  // =========================

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // =========================
  // PILIH VARIAN
  // =========================

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectSugar(String sugar) {
    selectedSugar.value = sugar;
  }

  void selectIce(String ice) {
    selectedIce.value = ice;
  }

  // =========================
  // BUY NOW
  // =========================

  void buyNow() {
    Get.toNamed(
      '/checkout',
      arguments: {
        'productName': productName,
        'productPrice': productPrice,
        'productImage': productImage,
        'quantity': quantity.value,
        'size': selectedSize.value,
        'sugar': selectedSugar.value,
        'ice': selectedIce.value,
      },
    );
  }

  // =========================
  // PRODUCT MAP
  // =========================

  Map<String, String> get productAsMap => {
  'name': productName,
  'image': productImage,
  'price': productPrice,
  'rating': productRating,
  'category': productCategory,
};

  // =========================
  // FAVORITE
  // =========================

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    final favCtrl = Get.find<FavoriteController>();
    favCtrl.toggleFavorite(productAsMap);
    showCustomSnackbar(
      isFavorite.value ? 'Favorit' : 'Batal Favorit',
      isFavorite.value
          ? '$productName ditambahkan ke favorit'
          : '$productName dihapus dari favorit',
    );
  }

  // =========================
  // ADD TO CART
  // =========================

  void addToCart() {
    final cartController = Get.find<CartController>();

    cartController.addItem(productAsMap);

    showCustomSnackbar('Keranjang', '$productName berhasil ditambahkan ke keranjang');
  }
}