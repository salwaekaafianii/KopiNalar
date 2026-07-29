import 'package:get/get.dart';
import 'package:kopi_bnsp/app/modules/home/bindings/home_binding.dart';
import 'package:kopi_bnsp/app/modules/home/views/home_view.dart';
import 'package:kopi_bnsp/app/modules/register/bindings/register_binding.dart';
import 'package:kopi_bnsp/app/modules/register/views/register_view.dart';

// Import views dan bindings dari masing-masing modul
import '../modules/all product/bindings/all_product_binding.dart';
import '../modules/all product/views/all_product_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/favorit/bindings/favorit_binding.dart';
import '../modules/favorit/views/favorit_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/product detail/bindings/product_detail_binding.dart';
import '../modules/product detail/views/product_detail_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/splash/bindings/splash_binding.dart';

import '../modules/login/views/login_view.dart';
import '../modules/login/bindings/login_binding.dart';

import '../modules/profile/views/profile_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/payment/views/payment_success_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/riwayat/views/order_detail_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/tentang/views/tentang_view.dart';
import '../modules/tentang/bindings/tentang_binding.dart';
import '../modules/alamat/views/alamat_view.dart';
import '../modules/alamat/bindings/alamat_binding.dart';
import '../modules/pengaturan/views/pengaturan_view.dart';
import '../modules/pengaturan/bindings/pengaturan_binding.dart';
import '../modules/admin/views/admin_view.dart';
import '../modules/admin/bindings/admin_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/register',
      page: () => const RegisterView(),
      binding: RegisterBinding(), // Binding dihubungkan di sini
    ),
    GetPage(
      name: Routes.home, // Bisa menggunakan Routes.home sesuai struktur Anda
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // Penambahan Rute Cart (Keranjang)
    GetPage(
      name: Routes
          .cart, // Pastikan Routes.cart sudah didefinisikan di app_routes.dart
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    // Di dalam AppPages / Routes
    GetPage(
      name: '/product-detail',
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: Routes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: Routes.allProducts,
      page: () => const AllProductsView(),
      binding: AllProductsBinding(),
    ),
    GetPage(
      name: Routes.favorite,
      page: () => const FavoriteView(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.payment,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: Routes.paymentSuccess,
      page: () => const PaymentSuccessView(),
    ),
    GetPage(
      name: Routes.riwayat,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: Routes.notifikasi,
      page: () => const NotifikasiView(),
      binding: NotifikasiBinding(),
    ),
    GetPage(
      name: Routes.tentang,
      page: () => const TentangView(),
      binding: TentangBinding(),
    ),
    GetPage(
      name: Routes.alamat,
      page: () => const AlamatView(),
      binding: AlamatBinding(),
    ),
    GetPage(
      name: Routes.pengaturan,
      page: () => const PengaturanView(),
      binding: PengaturanBinding(),
    ),
    GetPage(
      name: Routes.orderDetail,
      page: () => const OrderDetailView(),
    ),
    GetPage(
      name: Routes.admin,
      page: () => const AdminView(),
      binding: AdminBinding(),
    ),
  ];
}
