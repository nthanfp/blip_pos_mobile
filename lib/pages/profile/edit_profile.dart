// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_final_fields

import 'package:blip_pos/service/profile/update_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:blip_pos/service/profile/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String _profileImage = 'assets/images/default_avatar.png';
  bool _isLoading = true; // Variabel untuk menunjukkan loading saat ambil data profil

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil data profil
  _fetchProfile() async {
    final response = await getProfile(); // Panggil service getProfile()

    if (response['success']) {
      final profileData = response['data']['data'];

      // Perbarui controller dengan data profil
      setState(() {
        _nameController.text = profileData['name'] ?? 'Nama Tidak Tersedia';
        _emailController.text = profileData['email'] ?? 'Email Tidak Tersedia';
        _isLoading = false; // Set loading ke false setelah data profil berhasil diambil
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data profil: ${response['message']}')),
      );
    }
  }

  // Fungsi untuk memilih gambar profil (gunakan ImagePicker atau plugin lainnya)
  _pickProfileImage() async {
    // Implementasikan pemilihan gambar profil jika diperlukan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Profil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: AssetImage(_profileImage),
                        child:
                            _profileImage == 'assets/images/default_avatar.png' ? const Icon(Icons.camera_alt, size: 30, color: Colors.white) : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
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
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Color(0xFF0060B8)),
                        filled: true,
                        fillColor: Colors.grey[200],
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        // Aksi simpan perubahan
                        final result = await UpdateProfileService.updateProfile(_nameController.text);

                        if (result['success']) {
                          // Jika berhasil, tampilkan SnackBar hijau
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Profil berhasil diperbarui!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Jika gagal, tampilkan SnackBar merah
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal memperbarui profil: ${result['message']}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
