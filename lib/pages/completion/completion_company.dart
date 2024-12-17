import 'package:flutter/material.dart';

class CompletionCompany extends StatefulWidget {
  const CompletionCompany({super.key});

  @override
  _CompletionCompanyState createState() => _CompletionCompanyState();
}

class _CompletionCompanyState extends State<CompletionCompany> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengelola input pengguna
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Fungsi untuk menyimpan data perusahaan
  void _saveCompany() {
    if (_formKey.currentState?.validate() ?? false) {
      // Ambil nilai dari controller
      final name = _nameController.text;
      final phone = _phoneController.text;
      final email = _emailController.text;

      // Simulasi simpan data (bisa diganti dengan API request)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perusahaan $name berhasil disimpan!')),
      );

      // Bisa lakukan API request di sini jika perlu
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lengkapi Data Perusahaan'),
        backgroundColor: const Color(0xFF0060B8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Nama Perusahaan
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Perusahaan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama perusahaan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Nomor Telepon
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Nomor telepon tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Perusahaan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Button untuk menyimpan data
                ElevatedButton(
                  onPressed: _saveCompany,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0060B8),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
