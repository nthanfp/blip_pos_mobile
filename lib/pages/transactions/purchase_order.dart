import 'package:blip_pos/pages/transactions/purchase_order_add.dart';
import 'package:blip_pos/service/transactions/purchases.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for currency formatting

class PurchaseOrderPage extends StatefulWidget {
  const PurchaseOrderPage({Key? key}) : super(key: key);

  @override
  _PurchaseOrderPageState createState() => _PurchaseOrderPageState();
}

class _PurchaseOrderPageState extends State<PurchaseOrderPage> {
  List<Map<String, dynamic>> _purchaseOrders = [];

  @override
  void initState() {
    super.initState();
    _refreshPurchaseOrders();
  }

  Future<void> _refreshPurchaseOrders() async {
    try {
      final purchaseOrders = await PurchaseOrderService().fetchPurchaseOrders();
      setState(() {
        _purchaseOrders = purchaseOrders;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil daftar pesanan pembelian: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Pembelian'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPurchaseOrderPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _purchaseOrders.isEmpty
          ? const Center(child: Text('Tidak ada pesanan pembelian ditemukan.'))
          : ListView.builder(
              itemCount: _purchaseOrders.length,
              itemBuilder: (ctx, index) {
                final order = _purchaseOrders[index];
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
                          builder: (context) => PurchaseOrderDetailsPage(order: order),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['po_number'] ?? 'Tidak ada Nomor PO',
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
                          Text('Pemasok: ${order['supplier_name'] ?? 'Tidak diketahui'}'),
                          Text('Tanggal Pesan: ${order['order_date'] ?? 'T/A'}'),
                          Text('Tanggal Diharapkan Tiba: ${order['expected_date'] ?? 'T/A'}'),
                          const SizedBox(height: 8),
                          Text(
                            'Jumlah: ${currencyFormatter.format(order['purchase_amount']?.toInt() ?? 0).replaceAll(RegExp(r',00'), '')}',
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

class PurchaseOrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const PurchaseOrderDetailsPage({required this.order, Key? key}) : super(key: key);

  @override
  State<PurchaseOrderDetailsPage> createState() => _PurchaseOrderDetailsPageState();
}

class _PurchaseOrderDetailsPageState extends State<PurchaseOrderDetailsPage> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  String? _selectedStatus;
  TextEditingController notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order['status'];
    notesController.text = widget.order['notes'] ?? '';
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Future<void> _updatePurchaseOrder() async {
    if (_formKey.currentState!.validate()) {
      final updatedOrderData = {
        'po_number': widget.order['po_number'],
        'status': _selectedStatus,
        'expected_date': widget.order['expected_date'],
        'notes': notesController.text,
      };

      try {
        await PurchaseOrderService().updatePurchaseOrder(widget.order['id'], updatedOrderData);
        // Tampilkan snackbar atau dialog sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan pembelian berhasil diperbarui')),
        );
        // Kembali ke halaman sebelumnya setelah pembaruan berhasil
        Navigator.pop(context);
      } catch (e) {
        // Tampilkan snackbar atau dialog error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui pesanan pembelian: $e')),
        );
      }
    }
  }

  Future<void> _deletePurchaseOrder() async {
    try {
      await PurchaseOrderService().deletePurchaseOrder(widget.order['id']);
      // Tampilkan snackbar atau dialog sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan pembelian berhasil dihapus')),
      );
      // Kembali ke halaman sebelumnya setelah penghapusan berhasil
      Navigator.pop(context);
    } catch (e) {
      // Tampilkan snackbar atau dialog error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pesanan pembelian: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan Pembelian #${widget.order['id']}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian Detail Pesanan
                const Text(
                  'Detail Pesanan:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.order['details'].length,
                  itemBuilder: (ctx, index) {
                    final detail = widget.order['details'][index];
                    return Card(
                      child: ListTile(
                        title: Text('Produk ID: ${detail['id_product']}'),
                        subtitle: Text(
                          'Jumlah: ${detail['quantity']} x ${currencyFormatter.format(double.parse(detail['price'])).replaceAll(RegExp(r',00'), '')}',
                        ),
                        trailing: Text(
                          '${currencyFormatter.format(detail['quantity'] * double.parse(detail['price'])).replaceAll(RegExp(r',00'), '')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Bagian Total
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '${currencyFormatter.format(widget.order['purchase_amount']).replaceAll(RegExp(r',00'), '')}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Bagian Catatan
                if (widget.order['notes'] != null)
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Catatan:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.order['notes']),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Bagian Edit Status
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edit Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          onChanged: (newValue) => setState(() => _selectedStatus = newValue),
                          items: ['pending', 'completed', 'canceled'].map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(_getStatusText(status)),
                            );
                          }).toList(),
                          decoration: const InputDecoration(labelText: 'Status'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Silakan pilih status';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: notesController,
                          decoration: const InputDecoration(labelText: 'Catatan'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _updatePurchaseOrder,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0060B8)),
                          child: const Text('Perbarui Pesanan', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol Hapus
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Tampilkan dialog konfirmasi sebelum menghapus
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Hapus'),
                              content: const Text('Apakah Anda yakin ingin menghapus pesanan pembelian ini?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Batal'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: const Text('Hapus'),
                                  onPressed: () {
                                    _deletePurchaseOrder();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Hapus Pesanan', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
