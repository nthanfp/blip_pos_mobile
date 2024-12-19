import 'dart:convert';
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiUrl = '${Config.apiUrl}/products';

  // Fetch product list
  Future<List<Map<String, dynamic>>> fetchProducts() async {
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
        return data.map((product) => product as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Add a new product
  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> productData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(productData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to create product: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to create product (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Fetch product by ID (Edit)
  Future<Map<String, dynamic>> fetchProductById(int productId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$productId/edit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  // Update product
  Future<Map<String, dynamic>> updateProduct(int productId, Map<String, dynamic> productData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(productData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to update product: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update product (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(int productId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (!responseData['success']) {
          throw Exception('Failed to delete product: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to delete product (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
