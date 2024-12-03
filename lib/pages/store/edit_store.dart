import 'package:flutter/material.dart';

class EditStorePage extends StatefulWidget {
  const EditStorePage({super.key});

  @override
  _EditStorePageState createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _subdistrictController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _storeNameController.text = 'Toko Melati';
    _emailController.text = 'tokomelati08@gmail.com';
    _phoneController.text = '085646877046';
    _provinceController.text = 'Jawa Barat';
    _cityController.text = 'Bandung';
    _districtController.text = 'Rancamanyar';
    _subdistrictController.text = 'Graha Rancamanyar';
    _postalCodeController.text = '40375';
    _addressController.text = 'Jl. Melati 1 No. 8 Graha Rancamanyar, RT 07 RW 18';
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _subdistrictController.dispose();
    _postalCodeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Toko', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone, // Menyesuaikan tipe untuk nomor telepon
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _provinceController,
                decoration: const InputDecoration(
                  labelText: 'Provinsi *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Kota *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _districtController,
                decoration: const InputDecoration(
                  labelText: 'Kecamatan *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _subdistrictController,
                decoration: const InputDecoration(
                  labelText: 'Kelurahan/Desa *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Pos *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _addressController,
                keyboardType: TextInputType.multiline, // Menyesuaikan agar bisa multiline
                maxLines: 4, // Membatasi jumlah baris di text area
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap *',
                  labelStyle: TextStyle(color: Color(0xFF0060B8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0060B8)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Toko berhasil diperbarui!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0060B8),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
