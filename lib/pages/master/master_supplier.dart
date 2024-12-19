import 'package:blip_pos/service/master/suppliers.dart';
import 'package:flutter/material.dart';

class MasterSupplier extends StatefulWidget {
  const MasterSupplier({super.key});

  @override
  _MasterSupplierState createState() => _MasterSupplierState();
}

class _MasterSupplierState extends State<MasterSupplier> {
  late Future<List<Map<String, dynamic>>> _suppliersFuture;

  @override
  void initState() {
    super.initState();
    _suppliersFuture = SupplierService().fetchSuppliers();
  }

  // Method to refresh the suppliers list after adding, editing or deleting a supplier
  void _refreshSuppliers() {
    setState(() {
      _suppliersFuture = SupplierService().fetchSuppliers();
    });
  }

  // Method to show the dialog for adding a new supplier
  void _showAddSupplierDialog() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressProvinceController = TextEditingController();
    final TextEditingController addressCityController = TextEditingController();
    final TextEditingController addressDistrictController = TextEditingController();
    final TextEditingController addressVillageController = TextEditingController();
    final TextEditingController addressPostalController = TextEditingController();
    final TextEditingController addressFullController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Supplier'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Supplier Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the supplier name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressProvinceController,
                  decoration: const InputDecoration(labelText: 'Province'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the province';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressCityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressDistrictController,
                  decoration: const InputDecoration(labelText: 'District'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the district';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressVillageController,
                  decoration: const InputDecoration(labelText: 'Village'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the village';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressPostalController,
                  decoration: const InputDecoration(labelText: 'Postal Code'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the postal code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressFullController,
                  decoration: const InputDecoration(labelText: 'Full Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the full address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final supplierData = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'address_province': addressProvinceController.text,
                    'address_city': addressCityController.text,
                    'address_district': addressDistrictController.text,
                    'address_village': addressVillageController.text,
                    'address_postal': addressPostalController.text,
                    'address_full': addressFullController.text,
                    'active': true, // Assume it's active by default
                  };
                  // Add the supplier using SupplierService
                  SupplierService().addSupplier(supplierData).then((response) {
                    _refreshSuppliers(); // Refresh the supplier list
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Supplier added successfully')),
                    );
                  }).catchError((e) {
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  });
                }
              },
              child: const Text('Add Supplier'),
            ),
          ],
        );
      },
    );
  }

  // Method to show the dialog for editing an existing supplier
  void _showEditSupplierDialog(Map<String, dynamic> supplier) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(text: supplier['name']);
    final TextEditingController emailController = TextEditingController(text: supplier['email']);
    final TextEditingController phoneController = TextEditingController(text: supplier['phone']);
    final TextEditingController addressProvinceController = TextEditingController(text: supplier['address_province']);
    final TextEditingController addressCityController = TextEditingController(text: supplier['address_city']);
    final TextEditingController addressDistrictController = TextEditingController(text: supplier['address_district']);
    final TextEditingController addressVillageController = TextEditingController(text: supplier['address_village']);
    final TextEditingController addressPostalController = TextEditingController(text: supplier['address_postal']);
    final TextEditingController addressFullController = TextEditingController(text: supplier['address_full']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Supplier'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Supplier Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the supplier name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressProvinceController,
                  decoration: const InputDecoration(labelText: 'Province'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the province';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressCityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressDistrictController,
                  decoration: const InputDecoration(labelText: 'District'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the district';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressVillageController,
                  decoration: const InputDecoration(labelText: 'Village'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the village';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressPostalController,
                  decoration: const InputDecoration(labelText: 'Postal Code'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the postal code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressFullController,
                  decoration: const InputDecoration(labelText: 'Full Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the full address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedData = {
                    'id': supplier['id'],
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'address_province': addressProvinceController.text,
                    'address_city': addressCityController.text,
                    'address_district': addressDistrictController.text,
                    'address_village': addressVillageController.text,
                    'address_postal': addressPostalController.text,
                    'address_full': addressFullController.text,
                    'active': supplier['active'],
                  };
                  // Update the supplier using SupplierService
                  SupplierService().updateSupplier(supplier['id'], updatedData).then((response) {
                    _refreshSuppliers(); // Refresh the supplier list
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Supplier updated successfully')),
                    );
                  }).catchError((e) {
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  });
                }
              },
              child: const Text('Update Supplier'),
            ),
          ],
        );
      },
    );
  }

  // Method to delete a supplier
  void _deleteSupplier(int supplierId) {
    SupplierService().deleteSupplier(supplierId).then((response) {
      _refreshSuppliers(); // Refresh the supplier list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supplier deleted successfully')),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supplier Management')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _suppliersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No suppliers found.'));
          }

          final suppliers = snapshot.data!;

          return ListView.builder(
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final supplier = suppliers[index];

              return ListTile(
                title: Text(supplier['name']),
                subtitle: Text(supplier['email']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditSupplierDialog(supplier),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteSupplier(supplier['id']),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSupplierDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
