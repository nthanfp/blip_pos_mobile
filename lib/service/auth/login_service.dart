import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';

Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('${Config.apiUrl}/auth/login');

  // Membuat payload JSON
  final body = json.encode({
    'email': email,
    'password': password,
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
        await TokenManager.saveToken(token);

        return {
          'success': true,
          'message': data['message'],
          'token': token,
          'data': data['data'],
          'user': data['data']['user'],
          'store': data['data']['store'],
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
      'message': 'Error during login: $e',
    };
  }
}
