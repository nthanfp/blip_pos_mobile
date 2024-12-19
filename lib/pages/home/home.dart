import 'package:blip_pos/pages/master/master_category.dart';
import 'package:blip_pos/pages/master/master_product.dart';
import 'package:blip_pos/pages/master/master_supplier.dart';
import 'package:blip_pos/pages/master/master_unit.dart';
import 'package:blip_pos/pages/profile/profile_setting.dart';
import 'package:blip_pos/pages/transactions/purchase_order.dart';
import 'package:blip_pos/pages/transactions/sales_order.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Jumlah kolom dalam grid
            mainAxisSpacing: 16, // Jarak antar baris
            crossAxisSpacing: 16, // Jarak antar kolom
            childAspectRatio: 1, // Proporsi ukuran kotak (1:1)
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () {
                // Navigasi atau aksi saat menu ditekan
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

  // Fungsi untuk menangani tap pada menu
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
