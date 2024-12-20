import 'dart:convert';
import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';
import 'package:http/http.dart' as http;

class SalesOrderService {
  final String apiUrl = '${Config.apiUrl}/sales-orders';

  // Fetch sales order list
  Future<List<Map<String, dynamic>>> fetchSalesOrders() async {
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
          return data.map((so) => so as Map<String, dynamic>).toList();
        } else {
          throw Exception('Failed to fetch sales orders: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to fetch sales orders (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch sales orders: $e');
    }
  }

  // Create sales order prepare
  Future<List<Map<String, dynamic>>> createSalesOrders() async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/create'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          final List<dynamic> productsData = responseData['data']['products'];
          return productsData.map((so) => so as Map<String, dynamic>).toList();
        } else {
          throw Exception('Failed to fetch sales orders: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to fetch sales orders (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch sales orders: $e');
    }
  }

  // Fetch payment methods only
  Future<List<Map<String, dynamic>>> fetchPaymentMethods() async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/create'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          final List<dynamic> payments = responseData['data']['payments'];
          return payments.map((payment) => payment as Map<String, dynamic>).toList();
        } else {
          throw Exception('Failed to fetch payment methods: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to fetch payment methods (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch payment methods: $e');
    }
  }

  // Add a new sales order
  Future<Map<String, dynamic>> addSalesOrder(Map<String, dynamic> salesOrderData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(salesOrderData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to create sales order: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to create sales order (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to create sales order: $e');
    }
  }

  // Fetch sales order by ID
  Future<Map<String, dynamic>> fetchSalesOrderById(int salesOrderId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$salesOrderId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        throw Exception('Failed to load sales order');
      }
    } catch (e) {
      throw Exception('Failed to load sales order: $e');
    }
  }

  // Update sales order
  Future<Map<String, dynamic>> updateSalesOrder(int salesOrderId, Map<String, dynamic> salesOrderData) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$salesOrderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(salesOrderData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Failed to update sales order: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update sales order (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to update sales order: $e');
    }
  }

  // Delete sales order
  Future<void> deleteSalesOrder(int salesOrderId) async {
    final token = await TokenManager.getToken();

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$salesOrderId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (!responseData['success']) {
          throw Exception('Failed to delete sales order: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to delete sales order (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to delete sales order: $e');
    }
  }
}
