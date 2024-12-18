import 'dart:convert';
import 'package:blip_pos/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:blip_pos/lib/token_manager.dart'; // Ganti sesuai dengan path token manager Anda

class PasswordService {
  // Fungsi untuk mengganti password
  static Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    const String url = '${Config.apiUrl}/user/change-password';
    final String? token = await TokenManager.getToken(); // Ambil token dari TokenManager

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {'success': true, 'message': responseBody['message']};
      } else {
        final responseBody = jsonDecode(response.body);
        return {'success': false, 'message': responseBody['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
