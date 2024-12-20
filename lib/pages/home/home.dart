import 'dart:convert';

import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';
import 'package:blip_pos/pages/transactions/sales_order_add.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:blip_pos/pages/master/master_category.dart';
import 'package:blip_pos/pages/master/master_product.dart';
import 'package:blip_pos/pages/master/master_supplier.dart';
import 'package:blip_pos/pages/master/master_unit.dart';
import 'package:blip_pos/pages/profile/profile_setting.dart';
import 'package:blip_pos/pages/transactions/purchase_order.dart';
import 'package:blip_pos/pages/transactions/sales_order.dart';
import 'package:blip_pos/service/transactions/sales.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int categories = 0;
  int units = 0;
  int products = 0;
  int suppliers = 0;
  int totalRevenue = 0;
  int totalCapitalCost = 0;
  int totalProfit = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        Uri.parse('${Config.apiUrl}/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          categories = data['categories'];
          units = data['units'];
          products = data['products'];
          suppliers = data['suppliers'];
          totalRevenue = data['total_revenue'];
          totalCapitalCost = data['total_capital_cost'];
          totalProfit = data['total_profit'];
        });
      } else {
        print('Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.shopping_cart, 'label': 'Penjualan'},
      {'icon': Icons.receipt, 'label': 'Pembelian'},
      {'icon': Icons.production_quantity_limits, 'label': 'Produk'},
      {'icon': Icons.category, 'label': 'Kategori'},
      {'icon': Icons.scale, 'label': 'Satuan'},
      {'icon': Icons.local_shipping, 'label': 'Pemasok'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLIP POS', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[50],
        child: Column(
          children: [
            Wrap(
              spacing: 16.0, // Spacing between cards
              runSpacing: 16.0, // Spacing between rows of cards
              children: [
                _buildStatCard(Icons.category, 'Kategori', categories),
                _buildStatCard(Icons.scale, 'Satuan', units),
                _buildStatCard(Icons.production_quantity_limits, 'Produk', products),
                _buildStatCard(Icons.local_shipping, 'Pemasok', suppliers),
                _buildStatCard(Icons.attach_money, 'Pendapatan', totalRevenue),
                _buildStatCard(Icons.money_off, 'Modal', totalCapitalCost),
                _buildStatCard(Icons.account_balance_wallet, 'Keuntungan', totalProfit),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return GestureDetector(
                    onTap: () {
                      _handleMenuTap(context, item['label']);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(item['icon'], size: 30, color: const Color(0xFF0060B8)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['label'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF0060B8),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AddSalesOrderPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SalesOrderPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileSettingPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(IconData icon, String label, int value) {
    return Column(
      children: [
        Icon(icon, size: 30, color: const Color(0xFF0060B8)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
        Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To prevent card from taking full height
          children: [
            Icon(icon, size: 30, color: const Color(0xFF0060B8)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
            Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _handleMenuTap(BuildContext context, String label) {
    switch (label) {
      case 'Penjualan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SalesOrderPage()),
        );
        break;
      case 'Pembelian':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PurchaseOrderPage()),
        );
        break;
      case 'Produk':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MasterProductPage()),
        );
        break;
      case 'Kategori':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MasterCategoryPage()),
        );
        break;
      case 'Satuan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MasterUnitPage()),
        );
        break;
      case 'Pemasok':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MasterSupplier()),
        );
        break;
      default:
        break;
    }
  }
}
