import 'package:flutter/material.dart';
import 'package:blip_pos/service/master/product.dart';
import 'package:blip_pos/service/master/category.dart';
import 'package:blip_pos/service/master/units.dart';

class MasterProductPage extends StatefulWidget {
  const MasterProductPage({Key? key}) : super(key: key);

  @override
  _MasterProductPageState createState() => _MasterProductPageState();
}

class _MasterProductPageState extends State<MasterProductPage> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _units = [];

  @override
  void initState() {
    super.initState();
    _refreshProducts();
    _loadCategories();
    _loadUnits();
  }

  Future<void> _refreshProducts() async {
    try {
      final products = await ProductService().fetchProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
      );
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService().fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching categories: $e')),
      );
    }
  }

  Future<void> _loadUnits() async {
    try {
      final units = await UnitService().fetchUnits();
      setState(() {
        _units = units;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching units: $e')),
      );
    }
  }

  Future<void> _showAddProductDialog({Map<String, dynamic>? product}) async {
    final productNameController = TextEditingController(text: product?['name'] ?? '');
    final productDescriptionController = TextEditingController(text: product?['description'] ?? '');
    final productSkuController = TextEditingController(text: product?['sku'] ?? '');
    final productWeightController = TextEditingController(text: product?['weight']?.toString() ?? '');
    final productStockController = TextEditingController(text: product?['stock']?.toString() ?? '');
    final productStockMinController = TextEditingController(text: product?['stock_min']?.toString() ?? '');
    final productPriceCapitalController = TextEditingController(text: product?['price_capital']?.toString() ?? '');
    final productPriceSellingController = TextEditingController(text: product?['price_selling']?.toString() ?? '');

    int? selectedCategoryId = product?['id_category'];
    int? selectedUnitId = product?['id_unit'];
    bool isPublished = product?['is_published'] ?? false;
    isPublished = product?['is_published'] == 1;

    // Open the dialog
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: productSkuController,
                decoration: const InputDecoration(labelText: 'SKU'),
              ),
              TextFormField(
                controller: productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextFormField(
                controller: productDescriptionController,
                decoration: const InputDecoration(labelText: 'Product Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: productWeightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: productStockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: productStockMinController,
                decoration: const InputDecoration(labelText: 'Minimum Stock'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: productPriceCapitalController,
                decoration: const InputDecoration(labelText: 'Price Capital'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: productPriceSellingController,
                decoration: const InputDecoration(labelText: 'Price Selling'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'],
                    child: Text(category['category_name'] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              DropdownButtonFormField<int>(
                value: selectedUnitId,
                items: _units.map((unit) {
                  return DropdownMenuItem<int>(
                    value: unit['id'],
                    child: Text(unit['unit_name'] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUnitId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Unit'),
              ),
              SwitchListTile(
                title: const Text('Published'),
                value: isPublished, // Pastikan isPublished bernilai boolean
                onChanged: (bool value) {
                  setState(() {
                    isPublished = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final productName = productNameController.text.trim();
              final productDescription = productDescriptionController.text.trim();
              final productSku = productSkuController.text.trim();
              final productWeight = double.tryParse(productWeightController.text.trim());
              final productStock = int.tryParse(productStockController.text.trim());
              final productStockMin = int.tryParse(productStockMinController.text.trim());
              final productPriceCapital = double.tryParse(productPriceCapitalController.text.trim());
              final productPriceSelling = double.tryParse(productPriceSellingController.text.trim());

              if (productName.isEmpty ||
                  productSku.isEmpty ||
                  productDescription.isEmpty ||
                  productWeight == null ||
                  productStock == null ||
                  productStockMin == null ||
                  productPriceCapital == null ||
                  productPriceSelling == null ||
                  selectedCategoryId == null ||
                  selectedUnitId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields.')),
                );
                return;
              }

              try {
                if (product == null) {
                  // Add product
                  await ProductService().addProduct({
                    'sku': productSku,
                    'name': productName,
                    'slug': productName.toLowerCase().replaceAll(' ', '-'),
                    'description': productDescription,
                    'weight': productWeight,
                    'stock': productStock,
                    'stock_min': productStockMin,
                    'price_capital': productPriceCapital,
                    'price_selling': productPriceSelling,
                    'id_category': selectedCategoryId,
                    'id_unit': selectedUnitId,
                    'is_published': isPublished,
                  });
                } else {
                  // Update product
                  await ProductService().updateProduct(product['id'], {
                    'sku': productSku,
                    'name': productName,
                    'slug': productName.toLowerCase().replaceAll(' ', '-'),
                    'description': productDescription,
                    'weight': productWeight,
                    'stock': productStock,
                    'stock_min': productStockMin,
                    'price_capital': productPriceCapital,
                    'price_selling': productPriceSelling,
                    'id_category': selectedCategoryId,
                    'id_unit': selectedUnitId,
                    'is_published': isPublished,
                  });
                }
                _refreshProducts();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product saved successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving product: $e')),
                );
              }
            },
            child: Text(product == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Di dalam class _MasterProductPageState
  Future<void> _deleteProduct(int productId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin menghapus produk ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () async {
                try {
                  await ProductService().deleteProduct(productId);
                  _refreshProducts();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produk berhasil dihapus')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus produk: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Product'),
      ),
      body: _products.isEmpty
          ? const Center(child: Text('No products found.'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (ctx, index) {
                final product = _products[index];

                return ListTile(
                  title: Text(product['name'] ?? 'No name'),
                  subtitle: Text('Price: Rp ${product['price_selling']} | Category: ${product['category_name'] ?? 'Unknown'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          try {
                            print(product['id']); // Tambahkan ini untuk cek ID produk
                            final productData = await ProductService().fetchProductById(product['id']);
                            _showAddProductDialog(product: productData);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error fetching product: $e')),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteProduct(product['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
