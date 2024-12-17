import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';

Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
  final url = Uri.parse('${Config.apiUrl}/auth/register');

  // Membuat payload JSON
  final body = json.encode({
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': passwordConfirmation,
  });

  try {
    // Kirim request POST ke API
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success']) {
        final token = data['data']['token'];
        final user = data['data']['user'];

        // Menyimpan token yang diterima
        await TokenManager.saveToken(token);

        return {
          'success': true,
          'message': data['message'],
          'token': token,
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': data['message'],
        };
      }
    } else {
      final data = json.decode(response.body);
      var msg = data['message'] ?? 'Failed to connect to the API.';

      return {
        'success': false,
        'message': msg,
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error during registration: $e',
    };
  }
}
