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

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Login berhasil
        _showSnackBar('Login successful!');
        
        // Navigasi ke HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else if (response.statusCode == 401) {
        // Unauthorized - email atau password salah
        _showSnackBar('Invalid email or password');
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
        }
        
        _showSnackBar(errorMessage);
      } else {
        // Server error atau error lainnya
        _showSnackBar('Login failed. Please try again.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('Network is unreachable')) {
        _showSnackBar('Cannot connect to server. Please check your connection.');
      } else {
        _showSnackBar('An error occurred: ${e.toString()}');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('successful') ? Colors.green : Colors.red,
      ),
    );
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
          ],
        ),
      ),
    );
  }
}