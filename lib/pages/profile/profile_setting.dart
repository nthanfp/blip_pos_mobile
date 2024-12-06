import 'package:blip_pos/pages/profile/change_password.dart';
import 'package:blip_pos/pages/profile/edit_profile.dart';
import 'package:blip_pos/pages/store/edit_store.dart';
import 'package:flutter/material.dart';
import 'package:blip_pos/service/profile/profile_service.dart'; // Import service profile

class ProfileSettingPage extends StatelessWidget {
  const ProfileSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, dynamic>>(
                future: getProfile(), // Ambil data profil
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Tampilkan loading
                  }

                  if (snapshot.hasError || !snapshot.hasData || !snapshot.data!['success']) {
                    return Text('Error: ${snapshot.data?['message'] ?? 'Unknown error'}'); // Tampilkan error jika gagal
                  }

                  final userProfile = snapshot.data!['data']; // Ambil data user
                  final name = userProfile['name'] ?? 'Nama Tidak Tersedia';
                  final username = userProfile['username'] ?? '${userProfile['email']}';

                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        username,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                },
              ),
              // Daftar menu
              Column(
                children: [
                  _buildListItem('Profil', Icons.arrow_forward_ios, context),
                  _buildListItem('Toko Saya', Icons.arrow_forward_ios, context),
                  _buildListItem('Ganti Password', Icons.arrow_forward_ios, context),
                  _buildListItem('Keluar', Icons.arrow_forward_ios, context),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: const Color(0xFF0060B8),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, IconData trailingIcon, BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(trailingIcon, size: 18),
      onTap: () {
        if (title == 'Profil') {
          // Arahkan ke halaman EditProfilePage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfilePage()),
          );
        } else if (title == 'Toko Saya') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditStorePage()),
          );
        } else if (title == 'Ganti Password') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
          );
        }
      },
    );
  }
}
