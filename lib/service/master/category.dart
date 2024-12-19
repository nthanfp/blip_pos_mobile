import 'dart:convert';
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String apiUrl = '${Config.apiUrl}/categories';

  // Fetch categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
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
        return data.map((category) => category as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // Add a new category
  Future<Map<String, dynamic>> addCategory(Map<String, dynamic> categoryData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(categoryData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to create category: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to create category (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  // Fetch category by ID (Edit)
  Future<Map<String, dynamic>> fetchCategoryById(int categoryId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$categoryId/edit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }

  // Update category
  Future<Map<String, dynamic>> updateCategory(int categoryId, Map<String, dynamic> categoryData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$categoryId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(categoryData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to update category: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update category (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(int categoryId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$categoryId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (!responseData['success']) {
          throw Exception('Failed to delete category: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to delete category (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
