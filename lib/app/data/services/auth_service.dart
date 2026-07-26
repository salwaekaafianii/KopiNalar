import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Observable: apakah user adalah tamu (belum login)
  final isGuest = true.obs;

  /// Inisialisasi: cek apakah user sudah login
  Future<void> init() async {
    final loggedIn = await _isLoggedIn();
    isGuest.value = !loggedIn;
  }

  /// Menyimpan token dan data user setelah login/register
  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userKey, value: jsonEncode(user));
    isGuest.value = false;
  }

  /// Mengambil token yang tersimpan
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Mengambil data user yang tersimpan
  Future<Map<String, dynamic>?> getUser() async {
    final userStr = await _storage.read(key: _userKey);
    if (userStr != null && userStr.isNotEmpty) {
      try {
        return jsonDecode(userStr) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Mengambil nama depan user
  Future<String> getFirstName() async {
    final user = await getUser();
    if (user != null && user['name'] != null) {
      final name = user['name'].toString();
      // Ambil kata pertama (nama depan)
      return name.split(' ').first;
    }
    return 'Pengunjung';
  }

  /// Cek apakah user sudah login (token ada) — private (pakai isGuest.obs saja)
  Future<bool> _isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Hapus session (logout)
  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    isGuest.value = true;
  }
}

