import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_input_field.dart';

class EditGudangScreen extends StatefulWidget {
  const EditGudangScreen({super.key});

  @override
  State<EditGudangScreen> createState() => _EditGudangScreenState();
}

class _EditGudangScreenState extends State<EditGudangScreen> {
  final TextEditingController _stockController = TextEditingController();
  String _selectedStock = '-- Select --';
  final List<String> _stockOptions = ['-- Select --', 'telur', 'bebek', 'pakan', 'alat'];

  Future<void> saveStock(String jenis, int jumlah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stok_$jenis', jumlah);
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.lightBlue,
                        ),
                        child: const Text('Gudang', style: AppTextStyles.heading),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  CustomDropdown(
                    label: 'Pilih stok',
                    value: _selectedStock,
                    items: _stockOptions,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStock = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomInputField(
                    placeholder: 'Masukkan jumlah stok',
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_selectedStock != '-- Select --' && _stockController.text.isNotEmpty) {
                          int jumlah = int.tryParse(_stockController.text) ?? 0;
                          await saveStock(_selectedStock, jumlah);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                        minimumSize: const Size(172, 0),
                      ),
                      child: const Text('Simpan', style: AppTextStyles.button),
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