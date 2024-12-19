import 'package:blip_pos/service/transactions/sales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesOrderDetailPage extends StatefulWidget {
  final int salesOrderId;

  SalesOrderDetailPage({Key? key, required this.salesOrderId}) : super(key: key);

  @override
  _SalesOrderDetailPageState createState() => _SalesOrderDetailPageState();
}

class _SalesOrderDetailPageState extends State<SalesOrderDetailPage> {
  Map<String, dynamic> _salesOrder = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSalesOrderDetail();
  }

  Future<void> _loadSalesOrderDetail() async {
    try {
      final salesOrder = await SalesOrderService().fetchSalesOrderById(widget.salesOrderId);
      setState(() {
        _salesOrder = salesOrder;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil detail pesanan penjualan: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan Penjualan'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Gunakan SingleChildScrollView untuk menghindari overflow
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor Penjualan: ${_salesOrder['sales_number'] ?? '-'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Tanggal: ${_salesOrder['order_date'] ?? '-'}'),
                  const SizedBox(height: 8),
                  Text('Status: ${_salesOrder['status'] ?? '-'}'),
                  const SizedBox(height: 8),
                  Text('Catatan: ${_salesOrder['notes'] ?? '-'}'),
                  const SizedBox(height: 8),
                  Text(
                    'Nama Kasir: ${_salesOrder['user']?['name'] ?? '-'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ringkasan Pembayaran:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryTile('Total', currencyFormatter.format(_salesOrder['order_amount'] ?? 0).replaceAll(RegExp(r',00'), '')),
                  _buildSummaryTile('Diskon', currencyFormatter.format(_salesOrder['discount_amount'] ?? 0).replaceAll(RegExp(r',00'), '')),
                  _buildSummaryTile('Total Bayar', currencyFormatter.format(_salesOrder['payment_amount'] ?? 0).replaceAll(RegExp(r',00'), '')),
                  _buildSummaryTile('Kembalian', currencyFormatter.format(_salesOrder['change_amount'] ?? 0).replaceAll(RegExp(r',00'), '')),
                  const SizedBox(height: 16),
                  const Text(
                    'Detail Pesanan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_salesOrder['sales_order_details'] != null)
                    ...(_salesOrder['sales_order_details'] as List)
                        .map((detail) => ListTile(
                              title: Text(detail['product']?['name'] ?? '-'),
                              subtitle: Text('${detail['price']} x ${detail['quantity']}'),
                              trailing: Builder(
                                builder: (context) {
                                  final price = detail['price'];
                                  final quantity = detail['quantity'];
                                  if (price is int && quantity is int) {
                                    final total = price * quantity;
                                    return Text('$total');
                                  } else {
                                    // Tangani error tipe data, misalnya dengan menampilkan pesan error
                                    return Text('Error: Tipe data tidak valid');
                                  }
                                },
                              ),
                            ))
                        .toList(),
                  // ... detail lainnya
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
