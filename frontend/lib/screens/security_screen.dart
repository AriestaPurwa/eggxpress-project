import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_input_field.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _savePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_password', _newPasswordController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keamanan Akun")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInputField(
              controller: _newPasswordController,
              placeholder: 'Password Baru',
              keyboardType: TextInputType.text,
              isPassword: true,
              onTogglePassword: () {},
            ),
            const SizedBox(height: 16),
            
            CustomInputField(
              controller: _confirmPasswordController,
              placeholder: 'Konfirmasi Password',
              keyboardType: TextInputType.text,
              isPassword: true,
              onTogglePassword: () {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePassword,
              child: const Text('Simpan Password'),
            )
          ],
        ),
      ),
    );
  }
}
