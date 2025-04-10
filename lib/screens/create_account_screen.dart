import 'package:flutter/material.dart';
import '../../widgets/custom_input_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 375),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0066FF),
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 24,
                        color: Color(0xFF0066FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomInputField(
                    controller: _emailController,
                    placeholder: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    showPasswordToggle: _showPassword,
                    onTogglePassword: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _phoneController,
                    placeholder: 'Your number',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Handle form submission
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}