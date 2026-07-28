import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.22:5000";

  /// Mengambil AuthService dari GetX (instance yang sudah di-register di main)
  AuthService get _authService => Get.find<AuthService>();

  /// Generate headers dengan token Authorization jika tersedia
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    final headers = <String, String>{
      "Content-Type": "application/json",
    };
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  Future<List<dynamic>> getProducts() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/products"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  // ============================================================
  // AUTH - REGISTER
  // ============================================================
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      // Simpan token dan data user setelah register
      if (data['token'] != null) {
        await _authService.saveSession(
          token: data['token'],
          user: data['user'] ?? {},
        );
      }
      return data;
    } else {
      throw Exception(data['message'] ?? "Gagal mendaftarkan akun");
    }
  }

  // ============================================================
  // AUTH - LOGIN
  // ============================================================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Simpan token dan data user setelah login
      if (data['token'] != null) {
        await _authService.saveSession(
          token: data['token'],
          user: data['user'] ?? {},
        );
      }
      return data;
    } else {
      throw Exception(data['message'] ?? "Gagal masuk");
    }
  }

  // ============================================================
  // AUTH - GET PROFILE
  // ============================================================
  Future<Map<String, dynamic>> getProfile() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/auth/profile"),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? "Gagal mengambil profil");
    }
  }

  // ============================================================
  // AUTH - UPDATE PROFILE
  // ============================================================
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? password,
  }) async {
    final headers = await _getHeaders();
    final body = <String, dynamic>{
      "name": name,
      "email": email,
    };
    if (password != null && password.isNotEmpty) {
      body["password"] = password;
    }
    final response = await http.put(
      Uri.parse("$baseUrl/auth/profile"),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 10));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['token'] != null) {
        await _authService.saveSession(
          token: data['token'],
          user: data['user'] ?? {},
        );
      }
      return data;
    } else {
      throw Exception(data['message'] ?? "Gagal memperbarui profil");
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  Future<void> logout() async {
    await _authService.clearSession();
  }

  // ============================================================
  // CART - GET CART
  // ============================================================
  Future<Map<String, dynamic>> getCart() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/cart"),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? "Gagal mengambil keranjang");
    }
  }

  // ============================================================
  // CART - SYNC CART
  // ============================================================
  Future<Map<String, dynamic>> syncCart(List<Map<String, dynamic>> items) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse("$baseUrl/cart/sync"),
      headers: headers,
      body: jsonEncode({"items": items}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? "Gagal menyinkronkan keranjang");
    }
  }

  // ============================================================
  // CART - CLEAR CART
  // ============================================================
  Future<void> clearCart() async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse("$baseUrl/cart"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "Gagal mengosongkan keranjang");
    }
  }

  // ============================================================
  // ADDRESS - GET ADDRESSES
  // ============================================================
  Future<List<dynamic>> getAddresses() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/address"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Gagal mengambil alamat");
    }
  }

  // ============================================================
  // ADDRESS - ADD ADDRESS
  // ============================================================
  Future<List<dynamic>> addAddress({
    required String label,
    required String alamat,
    required String kecamatan,
    required String kota,
    required String lat,
    required String lng,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse("$baseUrl/address"),
      headers: headers,
      body: jsonEncode({
        "label": label,
        "alamat": alamat,
        "kecamatan": kecamatan,
        "kota": kota,
        "lat": lat,
        "lng": lng,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data['data'];
    } else {
      throw Exception(data['message'] ?? "Gagal menambah alamat");
    }
  }

  // ============================================================
  // ADDRESS - DELETE ADDRESS
  // ============================================================
  Future<void> deleteAddress(String label) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse("$baseUrl/address/${Uri.encodeComponent(label)}"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "Gagal menghapus alamat");
    }
  }

  // ============================================================
  // FAVORITES - GET FAVORITES
  // ============================================================
  Future<List<dynamic>> getFavorites() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/favorites"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Gagal mengambil favorit");
    }
  }

  // ============================================================
  // FAVORITES - ADD FAVORITE
  // ============================================================
  Future<void> addFavorite({
    required String name,
    required String category,
    required String price,
    required String rating,
    required String description,
    required String image,
    String productId = '',
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse("$baseUrl/favorites"),
      headers: headers,
      body: jsonEncode({
        "name": name,
        "category": category,
        "price": price,
        "rating": rating,
        "description": description,
        "image": image,
        "productId": productId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? "Gagal menambah favorit");
    }
  }

  // ============================================================
  // FAVORITES - REMOVE FAVORITE
  // ============================================================
  Future<void> removeFavorite(String name) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse("$baseUrl/favorites/${Uri.encodeComponent(name)}"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "Gagal menghapus favorit");
    }
  }

  // ============================================================
  // ORDER - CREATE ORDER
  // ============================================================
  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required double totalPayment,
    required double shippingCost,
    required String paymentMethod,
    required String status,
    required Map<String, dynamic> customer,
    required Map<String, dynamic> address,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse("$baseUrl/orders"),
      headers: headers,
      body: jsonEncode({
        "items": items,
        "totalPayment": totalPayment,
        "shippingCost": shippingCost,
        "paymentMethod": paymentMethod,
        "status": status,
        "customer": customer,
        "address": address,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data['data'];
    } else {
      throw Exception(data['message'] ?? "Gagal membuat pesanan");
    }
  }

  // ============================================================
  // ORDER - GET ORDERS
  // ============================================================
  Future<List<dynamic>> getOrders() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/orders"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Gagal mengambil pesanan");
    }
  }

  // ============================================================
  // NOTIFICATIONS — GET NOTIFICATIONS
  // ============================================================
  Future<List<dynamic>> getNotifications() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/notifications"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Gagal mengambil notifikasi");
    }
  }

  // ============================================================
  // NOTIFICATIONS — MARK AS READ
  // ============================================================
  Future<void> markNotificationAsRead(String id) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse("$baseUrl/notifications/$id/read"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "Gagal menandai notifikasi");
    }
  }

  // ============================================================
  // NOTIFICATIONS — MARK ALL AS READ
  // ============================================================
  Future<void> markAllNotificationsAsRead() async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse("$baseUrl/notifications/read-all"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "Gagal menandai semua notifikasi");
    }
  }

  // ============================================================
  // NOTIFICATIONS — DELETE NOTIFICATION
  // ============================================================
  Future<void> deleteNotification(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse("$baseUrl/notifications/$id"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "Gagal menghapus notifikasi");
    }
  }

  // ============================================================
  // ADMIN — GET ALL ORDERS
  // ============================================================
  Future<List<dynamic>> getAdminOrders() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/admin/orders"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } else {
      throw Exception("Gagal mengambil data pesanan");
    }
  }

  // ============================================================
  // ADMIN — UPDATE ORDER STATUS
  // ============================================================
  Future<void> updateOrderStatus(String orderId, String status) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/orders/$orderId/status"),
      headers: headers,
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "Gagal memperbarui status");
    }
  }

  // ============================================================
  // ADMIN — GET ORDER STATS
  // ============================================================
  Future<Map<String, dynamic>> getOrderStats() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/admin/orders/stats"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? {};
    } else {
      throw Exception("Gagal mengambil statistik");
    }
  }
}
