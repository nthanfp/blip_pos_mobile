import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();

  // Simpan token di secure storage
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Ambil token dari secure storage
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Hapus token dari secure storage
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Periksa apakah token ada
  static Future<bool> hasToken() async {
    String? token = await getToken();
    return token != null;
  }
}
