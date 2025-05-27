import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart'; // Ganti path jika berbeda
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  // API Configuration
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String loginEndpoint = '/api/login';

  // Fungsi untuk menyimpan data login ke SharedPreferences
  Future<void> _saveLoginData(Map<String, dynamic> responseData) async {
    try {
      print('=== DEBUGGING SAVE LOGIN DATA ===');
      print('Raw responseData: $responseData');
      print('responseData type: ${responseData.runtimeType}');
      print('responseData keys: ${responseData.keys.toList()}');
      
      final prefs = await SharedPreferences.getInstance();
      
      // Debugging: Print semua struktur response secara detail
      responseData.forEach((key, value) {
        print('Key: $key, Value: $value, Type: ${value.runtimeType}');
        if (value is Map<String, dynamic>) {
          print('  Nested keys: ${value.keys.toList()}');
        }
      });
      
      String? token;
      Map<String, dynamic>? userData;
      
      // Expanded token search - cek semua kemungkinan
      final tokenSearchPaths = [
        ['token'],
        ['access_token'],
        ['auth_token'],
        ['bearer_token'],
        ['data', 'token'],
        ['data', 'access_token'],
        ['data', 'auth_token'],
        ['user', 'token'],
        ['user', 'access_token'],
        ['response', 'token'],
        ['response', 'access_token'],
        ['result', 'token'],
        ['result', 'access_token'],
      ];
      
      for (List<String> path in tokenSearchPaths) {
        dynamic current = responseData;
        bool found = true;
        
        for (String key in path) {
          if (current is Map<String, dynamic> && current.containsKey(key)) {
            current = current[key];
          } else {
            found = false;
            break;
          }
        }
        
        if (found && current != null) {
          token = current.toString();
          print('✅ Token ditemukan di ${path.join(".")}: $token');
          break;
        }
      }
      
      // Expanded user data search
      final userDataSearchPaths = [
        ['user'],
        ['data', 'user'],
        ['data'],
        ['profile'],
        ['user_info'],
        responseData.containsKey('id') ? [] : null, // Root level jika ada ID
      ].where((path) => path != null).cast<List<String>>();
      
      for (List<String> path in userDataSearchPaths) {
        dynamic current = responseData;
        bool found = true;
        
        if (path.isEmpty) {
          // Root level check
          if (responseData.containsKey('id')) {
            userData = responseData;
            found = true;
          } else {
            found = false;
          }
        } else {
          for (String key in path) {
            if (current is Map<String, dynamic> && current.containsKey(key)) {
              current = current[key];
            } else {
              found = false;
              break;
            }
          }
        }
        
        if (found && current is Map<String, dynamic>) {
          userData = current;
          print('✅ User data ditemukan di ${path.isEmpty ? 'root' : path.join(".")}: $userData');
          break;
        }
      }
      
      // Jika masih tidak ditemukan, coba cari berdasarkan field yang ada
      if (token == null) {
        print('🔍 Token tidak ditemukan di lokasi standar, mencari berdasarkan pattern...');
        responseData.forEach((key, value) {
          if (key.toLowerCase().contains('token') && value != null) {
            token = value.toString();
            print('✅ Token ditemukan berdasarkan pattern di key "$key": $token');
          }
        });
      }
      
      if (userData == null) {
        print('🔍 User data tidak ditemukan di lokasi standar, mencari berdasarkan field ID...');
        // Cari objek yang memiliki field 'id' atau 'email'
        responseData.forEach((key, value) {
          if (value is Map<String, dynamic> && 
              (value.containsKey('id') || value.containsKey('email'))) {
            userData = value;
            print('✅ User data ditemukan berdasarkan field ID/email di key "$key": $userData');
          }
        });
      }
      
      // Simpan token jika ditemukan
      if (token != null && token!.isNotEmpty) {
        await prefs.setString('auth_token', token!);
        print('✅ Token berhasil disimpan: $token');
      } else {
        print('❌ Token tidak bisa disimpan karena tidak ditemukan atau kosong');
        // Untuk debugging, tampilkan semua key yang mengandung kata 'token'
        final tokenKeys = responseData.keys.where((key) => 
          key.toLowerCase().contains('token')).toList();
        print('Keys yang mengandung "token": $tokenKeys');
      }
      
      // Simpan user data jika ditemukan
      if (userData != null) {
        // Simpan user ID
        if (userData!['id'] != null) {
          await prefs.setString('user_id', userData!['id'].toString());
          print('✅ User ID berhasil disimpan: ${userData!['id']}');
        }
        
        // Simpan data user lengkap sebagai JSON string
        await prefs.setString('user_data', json.encode(userData!));
        print('✅ User data berhasil disimpan: ${json.encode(userData!)}');
        
        // Simpan data individual untuk akses mudah
        final commonFields = ['email', 'nama', 'name', 'username', 'role', 'role_id'];
        for (String field in commonFields) {
          if (userData![field] != null) {
            await prefs.setString('user_$field', userData![field].toString());
            print('✅ Field $field disimpan: ${userData![field]}');
          }
        }
      } else {
        print('❌ User data tidak bisa disimpan karena tidak ditemukan');
      }

      print('=== VERIFIKASI DATA TERSIMPAN ===');
      final keys = prefs.getKeys();
      for (String key in keys) {
        final value = prefs.get(key);
        print('$key: $value');
      }
      print('================================');
      
    } catch (e) {
      print('❌ Error saving login data: $e');
      print('Stack trace: ${StackTrace.current}');
      throw Exception('Failed to save login data: $e');
    }
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill all fields');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl$loginEndpoint');
      
      print('Login URL: $url'); // Debug log
      print('Login Data: {"email": "$email", "password": "***"}'); // Debug log
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Response Status: ${response.statusCode}'); // Debug log
      print('Response Headers: ${response.headers}'); // Debug log
      print('Response Body: ${response.body}'); // Debug log

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Tambahan debugging untuk struktur response
        print('=== DETAILED RESPONSE ANALYSIS ===');
        print('Response type: ${responseData.runtimeType}');
        if (responseData is Map<String, dynamic>) {
          responseData.forEach((key, value) {
            print('$key: $value (${value.runtimeType})');
            if (value is Map<String, dynamic>) {
              value.forEach((nestedKey, nestedValue) {
                print('  $nestedKey: $nestedValue (${nestedValue.runtimeType})');
              });
            }
          });
        }
        print('=================================');
        
        // Simpan data login ke SharedPreferences
        await _saveLoginData(responseData);
        
        // Verifikasi token tersimpan
        final prefs = await SharedPreferences.getInstance();
        final savedToken = prefs.getString('auth_token');
        print('🔍 Verifikasi token setelah disimpan: $savedToken');
        
        if (savedToken == null || savedToken.isEmpty) {
          print('⚠️ WARNING: Token tidak tersimpan dengan benar!');
          _showSnackBar('Login successful but token issue detected. Check logs.');
        } else {
          _showSnackBar('Login successful!');
        }
        
        // Navigasi ke HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else if (response.statusCode == 401) {
        // Unauthorized - email atau password salah
        final responseData = json.decode(response.body);
        String message = 'Invalid email or password';
        
        if (responseData['message'] != null) {
          message = responseData['message'];
        }
        
        _showSnackBar(message);
      } else if (response.statusCode == 422) {
        // Validation error
        final responseData = json.decode(response.body);
        String errorMessage = 'Validation error';
        
        if (responseData['errors'] != null) {
          // Extract validation errors
          Map<String, dynamic> errors = responseData['errors'];
          List<String> errorMessages = [];
          errors.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.cast<String>());
            }
          });
          errorMessage = errorMessages.join(', ');
        } else if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        }
        
        _showSnackBar(errorMessage);
      } else {
        // Server error atau error lainnya
        final responseData = json.decode(response.body);
        String message = 'Login failed. Please try again.';
        
        if (responseData['message'] != null) {
          message = responseData['message'];
        }
        
        _showSnackBar(message);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      print('Login Error: $e'); // Debug log
      
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('Network is unreachable')) {
        _showSnackBar('Cannot connect to server. Please check your connection.');
      } else {
        _showSnackBar('An error occurred: ${e.toString()}');
      }
    }
  }

  // Fungsi untuk testing - cek data yang tersimpan
  Future<void> _debugSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('=== DEBUG SHARED PREFERENCES ===');
    for (String key in keys) {
      print('$key: ${prefs.get(key)}');
    }
    print('================================');
    
    // Show dialog dengan informasi
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('SharedPreferences Debug'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: keys.map((key) => 
                Text('$key: ${prefs.get(key)}', 
                     style: const TextStyle(fontSize: 12))).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.contains('successful') ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Tombol debug untuk development
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.grey),
            onPressed: _debugSharedPreferences,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: AppTheme.titleStyle.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Please log in to continue',
              style: AppTheme.subtitleStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Email Field
            TextField(
              controller: emailController,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),

            // Password Field
            TextField(
              controller: passwordController,
              enabled: !isLoading,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => loginUser(),
            ),
            const SizedBox(height: 32),

            // Login Button
            PrimaryButton(
              text: isLoading ? 'Logging in...' : 'Login',
              onPressed: isLoading ? () {} : () => loginUser(),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            // Development info
            const SizedBox(height: 20),
            Container(
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
                    'Development Info:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'API: $baseUrl$loginEndpoint',
                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  ),
                  const Text(
                    'Tekan tombol bug di AppBar untuk cek SharedPreferences',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}