import 'package:flutter/material.dart';
import 'package:blip_pos/service/transactions/sales.dart'; // Pastikan path ini benar

class AddSalesOrderPage extends StatefulWidget {
  const AddSalesOrderPage({Key? key}) : super(key: key);

  @override
  _AddSalesOrderPageState createState() => _AddSalesOrderPageState();
}

class _AddSalesOrderPageState extends State<AddSalesOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _salesNumberController = TextEditingController();
  final _notesController = TextEditingController();
  int? _selectedPaymentId; // Untuk menyimpan ID pembayaran yang dipilih
  double _paymentAmount = 0.0;
  List<Map<String, dynamic>> _selectedProducts = []; // Untuk menyimpan produk yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pesanan Penjualan'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Gunakan SingleChildScrollView
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _salesNumberController,
                decoration: const InputDecoration(labelText: 'Nomor Penjualan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor penjualan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Catatan'),
              ),
              const SizedBox(height: 16.0),
              // Dropdown untuk memilih metode pembayaran
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Metode Pembayaran'),
                value: _selectedPaymentId,
                items: [
                  // TODO: Ganti dengan data metode pembayaran dari API
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Metode Pembayaran 1'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Metode Pembayaran 2'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Metode pembayaran harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Pembayaran'),
                onChanged: (value) {
                  setState(() {
                    _paymentAmount = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah pembayaran harus diisi';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Jumlah pembayaran tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Bagian untuk memilih produk (TODO)
              // ...
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitSalesOrder,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitSalesOrder() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Validasi _selectedProducts

      final salesOrderData = {
        'sales_number': _salesNumberController.text,
        'notes': _notesController.text,
        'id_payment': _selectedPaymentId,
        'payment_amount': _paymentAmount,
        'details': _selectedProducts,
      };

      try {
        await SalesOrderService().addSalesOrder(salesOrderData);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan penjualan berhasil ditambahkan'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan pesanan penjualan: $e'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _salesNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
