// ignore_for_file: use_build_context_synchronously

import 'package:blip_pos/pages/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:blip_pos/pages/profile/profile_setting.dart';
import 'package:blip_pos/service/auth/login_service.dart';
import 'package:blip_pos/pages/completion/completion_company.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          // Header LOGO
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/header.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text - Heading Info
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Masuk untuk melanjutkan',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),

                // Form - Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Email',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0060B8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Form - Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0060B8),
                      ),
                    ),
                    suffixIcon: Icon(Icons.visibility),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Button - Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text;
                      final password = passwordController.text;

                      // Panggil fungsi login
                      var result = await login(email, password);

                      if (result['success']) {
                        final storeData = result['store'];

                        // print(profileData);

                        // Cek apakah pengguna memiliki store
                        if (storeData['has_store'] == false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CompletionCompany()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileSettingPage()),
                          );
                        }

                        // if (profileData != null && profileData['companies'] != null && profileData['companies'].isNotEmpty) {
                        //   if (profileData['companies'][0]['id'] == null) {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => const CompletionCompany()),
                        //     );
                        //   } else if (profileData != null && profileData['stores'][0]['id'] == null) {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => const CompletionStore()),
                        //     );
                        //   }
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text(result['message'])),
                        //   );
                        // }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF0060B8),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Text - Belum punya akun
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum Punya Akun? ",
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                      Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF0060B8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
