import 'package:blip_pos/service/master/product.dart';
import 'package:blip_pos/service/master/suppliers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blip_pos/service/transactions/purchases.dart'; // Pastikan import service Anda

class AddPurchaseOrderPage extends StatefulWidget {
  const AddPurchaseOrderPage({Key? key}) : super(key: key);

  @override
  State<AddPurchaseOrderPage> createState() => _AddPurchaseOrderPageState();
}

class _AddPurchaseOrderPageState extends State<AddPurchaseOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  TextEditingController poNumberController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController orderDateController = TextEditingController();
  TextEditingController expectedDateController = TextEditingController();
  String? _selectedStatus;
  TextEditingController notesController = TextEditingController();
  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> _suppliers = [];
  int? _selectedSupplierId;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _selectedStatus = 'pending'; // Default status
    orderDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    expectedDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _generatePoNumber();
    _fetchSuppliers();
    _fetchProducts();
  }

  @override
  void dispose() {
    poNumberController.dispose();
    supplierController.dispose();
    orderDateController.dispose();
    expectedDateController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _generatePoNumber() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
    final randomNumber = (now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0');
    final poNumber = 'INV-PO-$formattedDate$randomNumber';
    poNumberController.text = poNumber;
  }

  Future<void> _fetchSuppliers() async {
    try {
      final suppliers = await SupplierService().fetchSuppliers();
      setState(() {
        _suppliers = suppliers;
      });
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pemasok: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _addPurchaseOrder() async {
    if (_formKey.currentState!.validate()) {
      print(supplierController.text);

      final newPurchaseOrderData = {
        'po_number': poNumberController.text,
        'id_supplier': _selectedSupplierId,
        'order_date': orderDateController.text,
        'expected_date': expectedDateController.text,
        'status': _selectedStatus,
        'notes': notesController.text,
        'details': details, // Sertakan detail pesanan
      };

      try {
        await PurchaseOrderService().addPurchaseOrder(newPurchaseOrderData);
        // Tampilkan snackbar atau dialog sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan pembelian berhasil ditambahkan')),
        );
        // Kembali ke halaman sebelumnya setelah penambahan berhasil
        Navigator.pop(context);
      } catch (e) {
        // Tampilkan snackbar atau dialog error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan pesanan pembelian: $e')),
        );
      }
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ProductService().fetchProducts();
      setState(() {
        _products = products;
      });
      print(_products);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data produk: $e')),
      );
    }
  }

  void _addDetail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Map<String, dynamic>? _selectedProduct;
        int _quantity = 0;
        double _price = 0;
        final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Detail Pesanan'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedProduct,
                      onChanged: (newValue) => setState(() => _selectedProduct = newValue),
                      items: _products.map((product) {
                        return DropdownMenuItem(
                          value: product,
                          child: Text(product['name']),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Produk'),
                      validator: (value) {
                        if (value == null) {
                          return 'Silakan pilih produk';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _quantity.toString(),
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() => _quantity = int.tryParse(value) ?? 0),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Quantity harus berupa angka';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _price == 0 ? '' : currencyFormatter.format(_price).replaceAll(RegExp(r',00'), ''),
                      decoration: const InputDecoration(labelText: 'Harga'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() => _price = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan masukkan harga';
                        }
                        if (double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) == null) {
                          return 'Harga harus berupa angka';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    if (_selectedProduct != null) {
                      this.setState(() {
                        details.add({
                          'id_product': _selectedProduct!['id'],
                          'quantity': _quantity,
                          'price': _price,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pesanan Pembelian'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: poNumberController,
                  decoration: const InputDecoration(labelText: 'Nomor PO'),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan masukkan nomor PO';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedSupplierId,
                  onChanged: (newValue) => setState(() => _selectedSupplierId = newValue),
                  items: _suppliers.map((supplier) {
                    return DropdownMenuItem<int>(
                      value: supplier['id'] as int,
                      child: Text(supplier['name']),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Pemasok'),
                  validator: (value) {
                    if (value == null) {
                      return 'Silakan pilih pemasok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: orderDateController,
                  decoration: const InputDecoration(labelText: 'Tanggal Pesan'),
                  onTap: () => _selectDate(context, orderDateController), // Panggil fungsi _selectDate
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: expectedDateController,
                  decoration: const InputDecoration(labelText: 'Tanggal Diharapkan Tiba'),
                  onTap: () => _selectDate(context, expectedDateController), // Panggil fungsi _selectDate
                ),
                const SizedBox(height: 16),
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

                // Bagian Detail Pesanan
                const Text(
                  'Detail Pesanan:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: details.length,
                  itemBuilder: (ctx, index) {
                    final detail = details[index];
                    return Card(
                      child: ListTile(
                        title: Text('Produk ID: ${detail['id_product']}'),
                        subtitle: Text(
                          'Jumlah: ${detail['quantity']} x ${currencyFormatter.format(detail['price']).replaceAll(RegExp(r',00'), '')}',
                        ),
                        trailing: Text(
                          '${currencyFormatter.format(detail['quantity'] * detail['price']).replaceAll(RegExp(r',00'), '')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addDetail,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0060B8)),
                  child: const Text('Tambah Detail', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _addPurchaseOrder,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0060B8)),
                  child: const Text('Simpan Pesanan', style: TextStyle(color: Colors.white)),
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
