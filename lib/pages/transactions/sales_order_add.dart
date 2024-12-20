import 'package:flutter/material.dart';
import 'package:blip_pos/service/transactions/sales.dart'; // Adjust the import path if needed

class AddSalesOrderPage extends StatefulWidget {
  const AddSalesOrderPage({Key? key}) : super(key: key);

  @override
  _AddSalesOrderPageState createState() => _AddSalesOrderPageState();
}

class _AddSalesOrderPageState extends State<AddSalesOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _salesNumberController = TextEditingController();
  final _notesController = TextEditingController();
  int? _selectedPaymentId; // For storing the selected payment ID
  double _paymentAmount = 0.0;
  List<Map<String, dynamic>> _selectedProducts = []; // For storing selected products
  List<Map<String, dynamic>> _products = []; // For storing the fetched products

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when the page is initialized
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await SalesOrderService().createSalesOrders();
      setState(() {
        _products = (data as List)
            .map((product) => {
                  'id': product['id'],
                  'name': product['name'],
                  'qty': 0, // Initialize quantity to 0
                })
            .toList();
      });
    } catch (e) {
      // Handle error, e.g., show a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data produk: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pesanan Penjualan'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
              // Dropdown untuk memilih metode pembayaran (Commented out)
              // ... (Dropdown code - commented out as per your previous instruction)

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

              SizedBox(
                height: 250, // Adjust the height as needed
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ListTile(
                      title: Text(product['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (product['qty'] > 0) {
                                  product['qty']--;
                                }
                              });
                            },
                          ),
                          Text('${product['qty']}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                product['qty']++;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

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
      // Filter products with qty > 0
      _selectedProducts = _products.where((product) => product['qty'] > 0).toList();

      // Create the sales order data
      final salesOrderData = {
        'sales_number': _salesNumberController.text,
        'notes': _notesController.text,
        'id_payment': 1, // Make sure this is set correctly
        'payment_amount': _paymentAmount, // Make sure this is set correctly
        'details': _selectedProducts
            .map((product) => {
                  'id_product': product['id'],
                  'quantity': product['qty'],
                })
            .toList(),
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
        Navigator.pop(context); // Return to the previous page
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
