import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';

Future<Map<String, dynamic>> getProfile() async {
  final token = await TokenManager.getToken();

  if (token == null) {
    return {
      'success': false,
      'message': 'Token not found. Please log in again.',
    };
  }

  final url = Uri.parse('${Config.apiUrl}/user/profile');

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return {
        'success': true,
        'data': data,
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to load profile. Status code: ${response.statusCode}',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error fetching profile: $e',
    };
  }
}
