// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:blip_pos/pages/completion/completion_store.dart';
import 'package:http/http.dart' as http;

import 'package:blip_pos/config/config.dart';
import 'package:blip_pos/lib/token_manager.dart';
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

  Future<void> _saveCompany() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Ambil nilai dari controller
      final name = _nameController.text;
      final phone = _phoneController.text;
      final email = _emailController.text;

      // Ambil token dari TokenManager
      final token = await TokenManager.getToken();

      if (token == null) {
        // Handle kasus token tidak ditemukan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token tidak ditemukan. Silakan login kembali.')),
        );
        return;
      }

      final url = Uri.parse('${Config.apiUrl}/completion/company');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = json.encode({
        'name': name,
        'phone': phone,
        'email': email,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          // Berhasil menyimpan data
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perusahaan $name berhasil disimpan!')),
          );

          // Navigasi ke halaman selanjutnya atau lakukan tindakan lain
          // Redirect ke CompletionStore
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CompletionStore()),
          );
        } else {
          // Handle error API
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'Gagal menyimpan data.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        // Handle error jaringan atau error lainnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
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
        title: const Text('Lengkapi Perusahaan', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0060B8)),
      ),
      body: Container(
        color: Colors.grey[50], // Warna background body
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  const Text(
                    'Lengkapi Profil Perusahaan',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pastikan data yang Anda masukkan benar.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Nama Perusahaan
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Perusahaan',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0060B8)),
                      ),
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0060B8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon tidak boleh kosong';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        // Match one or more digits
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF0060B8)),
                      ),
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
                  SizedBox(
                    width: double.infinity, // Lebar tombol penuh
                    child: ElevatedButton(
                      onPressed: _saveCompany,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0060B8),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
