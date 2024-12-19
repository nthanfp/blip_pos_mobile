import 'dart:convert';
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';
import 'package:http/http.dart' as http;

class UnitService {
  final String apiUrl = '${Config.apiUrl}/units';

  // Fetch units
  Future<List<Map<String, dynamic>>> fetchUnits() async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((unit) => unit as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load units');
      }
    } catch (e) {
      throw Exception('Failed to load units: $e');
    }
  }

  // Add a new unit
  Future<Map<String, dynamic>> addUnit(Map<String, dynamic> unitData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(unitData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to create unit: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to create unit (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to create unit: $e');
    }
  }

  // Fetch unit by ID (Edit)
  Future<Map<String, dynamic>> fetchUnitById(int unitId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$unitId/edit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        throw Exception('Failed to load unit');
      }
    } catch (e) {
      throw Exception('Failed to load unit: $e');
    }
  }

  // Update unit
  Future<Map<String, dynamic>> updateUnit(int unitId, Map<String, dynamic> unitData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$unitId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(unitData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to update unit: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update unit (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to update unit: $e');
    }
  }

  // Delete unit
  Future<void> deleteUnit(int unitId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$unitId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (!responseData['success']) {
          throw Exception('Failed to delete unit: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to delete unit (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to delete unit: $e');
    }
  }
}
