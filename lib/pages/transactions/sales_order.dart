import 'package:blip_pos/pages/transactions/sales_order_add.dart';
import 'package:blip_pos/pages/transactions/sales_order_detail.dart';
import 'package:blip_pos/service/transactions/sales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesOrderPage extends StatefulWidget {
  const SalesOrderPage({Key? key}) : super(key: key);

  @override
  _SalesOrderPageState createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends State<SalesOrderPage> {
  List<Map<String, dynamic>> _salesOrders = [];

  @override
  void initState() {
    super.initState();
    _refreshSalesOrders();
  }

  Future<void> _refreshSalesOrders() async {
    try {
      final salesOrders = await SalesOrderService().fetchSalesOrders();
      setState(() {
        _salesOrders = salesOrders;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil daftar pesanan penjualan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Penjualan'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSalesOrderPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _salesOrders.isEmpty
          ? const Center(child: Text('Tidak ada pesanan penjualan ditemukan.'))
          : RefreshIndicator(
              // Tambahkan RefreshIndicator
              onRefresh: _refreshSalesOrders, // Refresh data saat pull-to-refresh
              child: ListView.builder(
                itemCount: _salesOrders.length,
                itemBuilder: (ctx, index) {
                  final order = _salesOrders[index];
                  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesOrderDetailPage(
                              salesOrderId: order['id'], // Mengirimkan ID sales order
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['sales_number'] ?? 'Tidak ada Nomor Penjualan',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order['status']),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getStatusText(order['status']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Tanggal: ${order['order_date'] ?? 'T/A'}'),
                            const SizedBox(height: 8),
                            Text(
                              'Jumlah: ${currencyFormatter.format(order['order_amount']?.toInt() ?? 0).replaceAll(RegExp(r',00'), '')}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  // Helper function to get color based on status
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper function to get Indonesian text for status
  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'completed':
        return 'Selesai';
      case 'canceled':
        return 'Dibatalkan';
      default:
        return 'T/A';
    }
  }
}
