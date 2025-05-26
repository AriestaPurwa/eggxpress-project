import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_input_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('profile_name') ?? '';
      _phoneController.text = prefs.getString('profile_phone') ?? '';
      _addressController.text = prefs.getString('profile_address') ?? '';
      _photoController.text = prefs.getString('profile_photo') ?? '';
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _nameController.text);
    await prefs.setString('profile_phone', _phoneController.text);
    await prefs.setString('profile_address', _addressController.text);
    await prefs.setString('profile_photo', _photoController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInputField(
              controller: _nameController,
              placeholder: 'Nama',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            
            CustomInputField(
              controller: _phoneController,
              placeholder: 'No HP',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _addressController,
              placeholder: 'Alamat',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),

            CustomInputField(
              controller: _photoController,
              placeholder: 'URL Foto',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Simpan Profil'),
            )
          ],
        ),
      ),
    );
  }
}
