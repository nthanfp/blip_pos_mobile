// ignore_for_file: use_build_context_synchronously

import 'package:blip_pos/pages/completion/completion_company.dart';
import 'package:blip_pos/pages/completion/completion_store.dart';
import 'package:flutter/material.dart';
import 'package:blip_pos/pages/auth/login.dart';
import 'package:blip_pos/pages/profile/profile_setting.dart';
import 'package:blip_pos/lib/token_manager.dart';
import 'package:blip_pos/service/profile/profile_service.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _checkTokenAndFetchProfile(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!['success']) {
          return _buildLoginScreen(context);
        }

        // Jika token valid, arahkan ke ProfileSettingPage
        return const ProfileSettingPage();
      },
    );
  }

  // Fungsi untuk memeriksa token dan mengambil data profil
  Future<Map<String, dynamic>> _checkTokenAndFetchProfile(BuildContext context) async {
    // Add context as a parameter
    final tokenExists = await TokenManager.hasToken();

    if (tokenExists) {
      try {
        final profileData = await getProfile();

        print("Raw profileData: $profileData");

        final companies = List.from(profileData['data']?['data']?['companies'] ?? []);
        final stores = List.from(profileData['data']?['data']?['stores'] ?? []);

        print("Companies: $companies");
        print("Stores: $stores");

        if (companies.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CompletionCompany()),
          );
        } else if (stores.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CompletionStore()),
          );
        }

        return {'success': true, 'profile': profileData};
      } catch (e) {
        print("Error: $e");
        return {'success': false, 'message': 'Failed to fetch profile. Please try again.'};
      }
    } else {
      return {'success': false, 'message': 'Token not found. Please log in.'};
    }
  }

  // Fungsi untuk menampilkan halaman login jika token tidak valid atau tidak ada
  Widget _buildLoginScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text(
                  'Tingkatkan Efisiensi Bisnis\ndengan BLIP POS',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF0060B8),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
