import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eggxpress/widgets/profile_header.dart' as header;
import 'package:eggxpress/widgets/profile_action_button.dart' as action;
import 'edit_profile_screen.dart';
import 'security_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  // Base URL untuk API - sesuaikan dengan server Anda
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Fungsi untuk mendapatkan token dari SharedPreferences
  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Coba beberapa kemungkinan nama key token
      String? token = prefs.getString('auth_token') ?? 
                     prefs.getString('token') ?? 
                     prefs.getString('access_token');
      print('Token dari SharedPreferences: $token'); // Debug log
      return token;
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Fungsi untuk mendapatkan user ID dari SharedPreferences
  Future<String?> _getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      print('User ID dari SharedPreferences: $userId'); // Debug log
      return userId;
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  // Fungsi untuk mendapatkan data user dari SharedPreferences
  Future<Map<String, dynamic>?> _getUserDataFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      if (userDataString != null && userDataString.isNotEmpty) {
        return json.decode(userDataString);
      }
      return null;
    } catch (e) {
      print('Error getting user data from prefs: $e');
      return null;
    }
  }

  // Fungsi untuk menyimpan data user ke SharedPreferences (jika diperlukan)
  Future<void> _saveUserData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(data));
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Fungsi untuk memanggil API GET /api/pengguna/{id}
  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Pertama, coba ambil data dari SharedPreferences
      final localUserData = await _getUserDataFromPrefs();
      if (localUserData != null) {
        print('Loading user data from SharedPreferences'); // Debug log
        setState(() {
          userData = localUserData;
          isLoading = false;
        });
        return;
      }

      // Jika tidak ada data lokal, coba ambil dari API
      final token = await _getAuthToken();
      final userId = await _getUserId();

      print('Loading profile from API - Token: $token, User ID: $userId'); // Debug log

      if (userId == null) {
        setState(() {
          error = 'User ID tidak ditemukan. Silakan login kembali.';
          isLoading = false;
        });
        return;
      }

      // Jika tidak ada token, coba tanpa token (untuk testing)
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final url = '$baseUrl/pengguna/$userId';
      print('API URL: $url'); // Debug log

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Berdasarkan response yang Anda berikan, data user langsung ada di root response
        // Tapi kita tetap cek jika ada wrapper 'data'
        final userInfo = data['data'] ?? data;
        
        setState(() {
          userData = userInfo;
          isLoading = false;
        });

        // Simpan data user untuk penggunaan di tempat lain
        await _saveUserData(userInfo);
        
      } else if (response.statusCode == 401) {
        // Token expired atau invalid
        setState(() {
          error = 'Sesi telah berakhir. Silakan login kembali.';
          isLoading = false;
        });
        _handleLogout();
      } else if (response.statusCode == 404) {
        setState(() {
          error = 'Data pengguna tidak ditemukan.';
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Gagal memuat data profil. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile: $e'); // Debug log
      setState(() {
        error = 'Terjadi kesalahan jaringan: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  // Fungsi untuk logout
  Future<void> _handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Hapus data user dari SharedPreferences
      await prefs.remove('auth_token');
      await prefs.remove('token');
      await prefs.remove('access_token');
      await prefs.remove('user_id');
      await prefs.remove('user_data');
      await prefs.remove('user_name');
      await prefs.remove('user_role');
      await prefs.remove('user_email');
      await prefs.remove('user_nama');
      // await prefs.clear(); // Uncomment jika ingin hapus semua data
      
      // Navigate ke welcome screen dan hapus semua route sebelumnya
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error during logout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saat logout: $e')),
        );
      }
    }
  }

  // Fungsi untuk refresh data
  Future<void> _refreshProfile() async {
    await _loadUserProfile();
  }

  // Fungsi untuk debug - cek semua data di SharedPreferences
  Future<void> _debugSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('=== DEBUG SHARED PREFERENCES ===');
    for (String key in keys) {
      print('$key: ${prefs.get(key)}');
    }
    print('================================');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // Tombol debug untuk development
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _debugSharedPreferences,
          ),
          // Tombol refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProfile,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Pass user data ke ProfileHeader
                isLoading
                    ? const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : error != null
                        ? SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.red.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      error!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadUserProfile,
                                    child: const Text('Coba Lagi'),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: _handleLogout,
                                    child: const Text('Login Ulang'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              // Tampilkan ProfileHeader dengan data user
                              header.ProfileHeader(),
                              
                              // Debug info (hapus di production)
                              if (userData != null)
                                Container(
                                  margin: const EdgeInsets.all(16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Data User (Debug):',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text('ID: ${userData!['id']}'),
                                      Text('Nama: ${userData!['nama']}'),
                                      Text('Email: ${userData!['email']}'),
                                      Text('No HP: ${userData!['no_hp']}'),
                                      Text('Alamat: ${userData!['alamat']}'),
                                      Text('Role: ${userData!['role']}'),
                                      Text('Created: ${userData!['created_at']}'),
                                      Text('Updated: ${userData!['updated_at']}'),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 45),
                      action.ProfileActionButton(
                        text: 'Edit profile information',
                        onTap: () async {
                          // Navigate ke edit profile dan tunggu hasil
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                          
                          // Jika ada perubahan, refresh data
                          if (result == true) {
                            _loadUserProfile();
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      action.ProfileActionButton(
                        text: 'Security',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SecurityScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 29),
                      const Text(
                        'Ganti akun',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 24.5 / 14,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 333),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Konfirmasi Logout'),
                                  content: const Text('Apakah Anda yakin ingin logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _handleLogout();
                                      },
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD9E4FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 70,
                            ),
                          ),
                          child: const Text(
                            'LOGOUT',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 27),
                    ],
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