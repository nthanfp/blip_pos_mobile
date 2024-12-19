import 'dart:convert';
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';
import 'package:http/http.dart' as http;

class SupplierService {
  final String apiUrl = '${Config.apiUrl}/suppliers';

  // Fetch suppliers
  Future<List<Map<String, dynamic>>> fetchSuppliers() async {
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
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load suppliers');
      }
    } catch (e) {
      throw Exception('Failed to load suppliers: $e');
    }
  }

  // Add a new supplier
  Future<Map<String, dynamic>> addSupplier(Map<String, dynamic> supplierData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(supplierData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to create supplier: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to create supplier (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to create supplier: $e');
    }
  }

  // Fetch supplier by ID (Edit)
  Future<Map<String, dynamic>> fetchSupplierById(int supplierId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$supplierId/edit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        throw Exception('Failed to load supplier');
      }
    } catch (e) {
      throw Exception('Failed to load supplier: $e');
    }
  }

  // Update supplier
  Future<Map<String, dynamic>> updateSupplier(int supplierId, Map<String, dynamic> supplierData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$supplierId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(supplierData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to update supplier: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update supplier (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to update supplier: $e');
    }
  }

  // Delete supplier
  Future<void> deleteSupplier(int supplierId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$supplierId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (!responseData['success']) {
          throw Exception('Failed to delete supplier: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to delete supplier (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to delete supplier: $e');
    }
  }
}
