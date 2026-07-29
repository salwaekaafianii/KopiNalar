part of 'app_pages.dart';

abstract class Routes {
  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const home = _Paths.home;
  static const cart = _Paths.cart; 
  static const productDetail = _Paths.productDetail;
  static const checkout = _Paths.checkout;
  static const allProducts = _Paths.allProducts;
  static const main = _Paths.main;
  static const favorite = _Paths.favorite;
  static const profile = _Paths.profile;
  static const payment = _Paths.payment;
  static const paymentSuccess = _Paths.paymentSuccess;
  static const riwayat = _Paths.riwayat;
  static const notifikasi = _Paths.notifikasi;
  static const bantuan = _Paths.bantuan;
  static const tentang = _Paths.tentang;
  static const alamat = _Paths.alamat;
  static const pengaturan = _Paths.pengaturan;
  static const admin = _Paths.admin;
  static const orderDetail = _Paths.orderDetail;
}

abstract class _Paths {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register'; 
  static const home = '/home';
  static const cart = '/cart'; 
  static const productDetail = '/product-detail';
  static const checkout = '/checkout';
  static const allProducts = '/all-products';
  static const main = '/main';
  static const favorite = '/favorite';
  static const profile = '/profile';
  static const payment = '/payment';
  static const paymentSuccess = '/payment-success';
  static const riwayat = '/riwayat';
  static const notifikasi = '/notifikasi';
  static const bantuan = '/bantuan';
  static const tentang = '/tentang';
  static const alamat = '/alamat';
  static const pengaturan = '/pengaturan';
  static const admin = '/admin';
  static const orderDetail = '/order-detail';
}
