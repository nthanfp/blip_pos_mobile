import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';

class UpdateProfileService {
  /// Update profile user
  static Future<Map<String, dynamic>> updateProfile(String name) async {
    // Ambil token dari TokenManager
    final token = await TokenManager.getToken();

    // Jika token tidak ditemukan
    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan. Silakan login kembali.',
      };
    }

    // URL endpoint update profile
    final url = Uri.parse('${Config.apiUrl}/user/update-profile');

    try {
      // Kirim permintaan POST
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
        }),
      );

      // Jika respons berhasil
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        // Jika respons gagal
        return {
          'success': false,
          'message': 'Gagal memperbarui profil. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Jika terjadi kesalahan
      return {
        'success': false,
        'message': 'Error saat memperbarui profil: $e',
      };
    }
  }
}
