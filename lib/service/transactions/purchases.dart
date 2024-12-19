import 'dart:convert';
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';
import 'package:http/http.dart' as http;

class PurchaseOrderService {
  final String apiUrl = '${Config.apiUrl}/purchase-orders';

  // Fetch purchase order list
  Future<List<Map<String, dynamic>>> fetchPurchaseOrders() async {
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
        if (responseData['success']) {
          final List<dynamic> data = responseData['data'];
          return data.map((po) => po as Map<String, dynamic>).toList();
        } else {
          throw Exception('Failed to fetch purchase orders: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to fetch purchase orders (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch purchase orders: $e');
    }
  }

  // Add a new purchase order
  Future<Map<String, dynamic>> addPurchaseOrder(Map<String, dynamic> purchaseOrderData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(purchaseOrderData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to create purchase order: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to create purchase order (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to create purchase order: $e');
    }
  }

  // Fetch purchase order by ID
  Future<Map<String, dynamic>> fetchPurchaseOrderById(int purchaseOrderId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$purchaseOrderId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        throw Exception('Failed to load purchase order');
      }
    } catch (e) {
      throw Exception('Failed to load purchase order: $e');
    }
  }

  // Update purchase order
  Future<Map<String, dynamic>> updatePurchaseOrder(int purchaseOrderId, Map<String, dynamic> purchaseOrderData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$purchaseOrderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(purchaseOrderData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to update purchase order: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update purchase order (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to update purchase order: $e');
    }
  }

  // Delete purchase order
  Future<void> deletePurchaseOrder(int purchaseOrderId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$purchaseOrderId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (!responseData['success']) {
          throw Exception('Failed to delete purchase order: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to delete purchase order (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to delete purchase order: $e');
    }
  }
}
