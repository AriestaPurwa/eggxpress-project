import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../widgets/custom_input_field.dart';
import 'home_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  File? _selectedImage;
  String? _imageUrl; // URL untuk NetworkImage
  final ImagePicker _picker = ImagePicker();

  // Base URL API
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _phoneController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // Function untuk memilih gambar
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageUrl = null; // Reset network image URL saat memilih file baru
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: ${e.toString()}');
    }
  }

  // Function untuk upload gambar dan mendapatkan URL
  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload-image'));
      
      request.files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path)
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['image_url'] != null) {
          return responseData['image_url'];
        }
      }
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function untuk register
  Future<void> _register() async {
    // Validasi input
    if (_namaController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _passwordConfirmController.text.trim().isEmpty) {
      _showErrorSnackBar('Semua field wajib diisi');
      return;
    }

    if (_passwordController.text != _passwordConfirmController.text) {
      _showErrorSnackBar('Password dan konfirmasi password tidak sama');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Password minimal 6 karakter');
      return;
    }

    // Validasi email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      _showErrorSnackBar('Format email tidak valid');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload image terlebih dahulu jika ada
      String? uploadedImageUrl;
      if (_selectedImage != null) {
        uploadedImageUrl = await _uploadImage();
        if (uploadedImageUrl != null) {
          setState(() {
            _imageUrl = uploadedImageUrl;
          });
        }
      }

      // Prepare registration data
      Map<String, dynamic> requestData = {
        'nama': _namaController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'password_confirmation': _passwordConfirmController.text,
        'role': 'user',
      };

      if (_phoneController.text.trim().isNotEmpty) {
        requestData['no_hp'] = _phoneController.text.trim();
      }
      
      if (_alamatController.text.trim().isNotEmpty) {
        requestData['alamat'] = _alamatController.text.trim();
      }

      // Add image URL if available
      if (uploadedImageUrl != null) {
        requestData['foto_url'] = uploadedImageUrl;
      }

      // Send registration request
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 && responseData['success'] == true) {
        // Registration successful
        _showSuccessSnackBar('Pendaftaran berhasil!');
        
        // Navigate to home screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        // Registration failed
        String errorMessage = 'Pendaftaran gagal';
        
        if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        } else if (responseData['errors'] != null) {
          // Handle validation errors
          Map<String, dynamic> errors = responseData['errors'];
          List<String> errorList = [];
          errors.forEach((key, value) {
            if (value is List) {
              errorList.addAll(value.cast<String>());
            }
          });
          errorMessage = errorList.join('\n');
        }
        
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      _showErrorSnackBar('Terjadi kesalahan: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Widget untuk menampilkan gambar
  Widget _buildProfileImage() {
    // Jika ada URL gambar dari network, gunakan NetworkImage
    if (_imageUrl != null) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF0066FF),
            width: 2,
          ),
          image: DecorationImage(
            image: NetworkImage(_imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    
    // Jika ada file lokal yang dipilih, gunakan FileImage
    if (_selectedImage != null) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF0066FF),
            width: 2,
          ),
          image: DecorationImage(
            image: FileImage(_selectedImage!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    
    // Default placeholder
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF0066FF),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.camera_alt,
        size: 30,
        color: Color(0xFF0066FF),
      ),
    );
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
                  
                  // Profile Picture Section
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: _buildProfileImage(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Tap to add photo (optional)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  CustomInputField(
                    controller: _namaController,
                    placeholder: 'Full Name *',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomInputField(
                    controller: _emailController,
                    placeholder: 'Email *',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomInputField(
                    controller: _passwordController,
                    placeholder: 'Password *',
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
                    controller: _passwordConfirmController,
                    placeholder: 'Confirm Password *',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    showPasswordToggle: _showConfirmPassword,
                    onTogglePassword: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  CustomInputField(
                    controller: _phoneController,
                    placeholder: 'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomInputField(
                    controller: _alamatController,
                    placeholder: 'Address',
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 32),

                  // Register Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Cancel Button
                  Center(
                    child: GestureDetector(
                      onTap: _isLoading ? null : () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: _isLoading ? const Color(0xFFCCCCCC) : const Color(0xFF999999),
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