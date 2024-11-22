import 'package:flutter/material.dart';

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
        color: Colors.grey[50], // Slightly different background
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Joko William',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.check_circle, color: Colors.blue, size: 18),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                '@jokwill',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  _buildListItem('Saved Messages', Icons.arrow_forward_ios),
                  _buildListItem('Recent Calls', Icons.arrow_forward_ios),
                  _buildListItem('Devices', Icons.arrow_forward_ios),
                  _buildListItem('Notifications', Icons.arrow_forward_ios),
                  _buildListItem('Appearance', Icons.arrow_forward_ios),
                  _buildListItem('Language', Icons.arrow_forward_ios),
                  _buildListItem('Privacy & Security', Icons.arrow_forward_ios),
                  _buildListItem('Storage', Icons.arrow_forward_ios),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF0060B8),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, IconData trailingIcon) {
    return ListTile(
      title: Text(title),
      trailing: Icon(trailingIcon, size: 18),
      onTap: () {
        // Handle navigation or action
      },
    );
  }
}
