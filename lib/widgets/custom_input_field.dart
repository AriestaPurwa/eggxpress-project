import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool showPasswordToggle;
  final VoidCallback? onTogglePassword;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.keyboardType,
    this.isPassword = false,
    this.showPasswordToggle = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !showPasswordToggle,
      decoration: InputDecoration(
        hintText: placeholder,
        filled: true,
        fillColor: const Color(0xFFEDEDED),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  showPasswordToggle ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: onTogglePassword,
              )
            : null,
      ),
    );
  }
}
