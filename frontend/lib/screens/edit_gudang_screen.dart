import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_input_field.dart';

class EditGudangScreen extends StatefulWidget {
  const EditGudangScreen({Key? key}) : super(key: key);

  @override
  State<EditGudangScreen> createState() => _EditGudangScreenState();
}

class _EditGudangScreenState extends State<EditGudangScreen> {
  final TextEditingController _stockController = TextEditingController();
  String _selectedStock = '-- Select --';
  final List<String> _stockOptions = ['-- Select --', 'Option 1', 'Option 2'];

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.fromLTRB(18, 31, 18, 220),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/dfa3a6d5de3a580cdd7eee6bd24bf07178251407?placeholderIfAbsent=true',
                      width: 107,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 52,
                        vertical: 29,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.lightBlue,
                      ),
                      child: const Text(
                        'Gudang',
                        style: AppTextStyles.heading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 167),
                CustomDropdown(
                  label: 'pilih stok',
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
                const SizedBox(height: 27),
                CustomInputField(
                  placeholder: 'masukkan jumlah stok', // ✅ pakai nama yang sesuai
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 70),
                ElevatedButton(
                  onPressed: () {
                    // Handle save action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 49,
                      vertical: 7,
                    ),
                    minimumSize: const Size(172, 0),
                  ),
                  child: const Text(
                    'Simpan',
                    style: AppTextStyles.button,
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
