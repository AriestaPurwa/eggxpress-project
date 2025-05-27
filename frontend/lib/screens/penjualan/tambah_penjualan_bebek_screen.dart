import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TambahPenjualanBebekScreen extends StatefulWidget {
  const TambahPenjualanBebekScreen({super.key});

  @override
  State<TambahPenjualanBebekScreen> createState() => _TambahPenjualanBebekScreenState();
}

class _TambahPenjualanBebekScreenState extends State<TambahPenjualanBebekScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _hargaController = TextEditingController();
  final _penggunaIdController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'proses';
  DateTime? _selectedTanggalAmbil;
  bool _isLoading = false;

  static const String baseUrl = 'http://127.0.0.1:8000/api/data-bebek';

  final List<String> _statusOptions = ['proses', 'selesai', 'dibatalkan'];

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final Map<String, dynamic> requestData = {
          'pengguna_id': int.parse(_penggunaIdController.text),
          'jumlah_bebek': int.parse(_jumlahController.text),
          'tanggal_input': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'status': _selectedStatus,
          'harga': int.parse(_hargaController.text), // Adding harga field
        };

        // Add tanggal_ambil if selected
        if (_selectedTanggalAmbil != null) {
          requestData['tanggal_ambil'] = DateFormat('yyyy-MM-dd').format(_selectedTanggalAmbil!);
        }

        final response = await http.post(
          Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(requestData),
        );

        if (response.statusCode == 201) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          
          if (responseData['success'] == true) {
            _showSuccessSnackBar('Data berhasil disimpan');
            Navigator.pop(context, true); // Return true to indicate success
          } else {
            _showErrorSnackBar(responseData['message'] ?? 'Gagal menyimpan data');
          }
        } else if (response.statusCode == 422) {
          // Validation error
          final Map<String, dynamic> errorData = json.decode(response.body);
          final Map<String, dynamic> errors = errorData['errors'] ?? {};
          
          String errorMessage = 'Validasi gagal:\n';
          errors.forEach((key, value) {
            if (value is List) {
              errorMessage += '• ${value.join(', ')}\n';
            }
          });
          
          _showErrorSnackBar(errorMessage);
        } else {
          _showErrorSnackBar('Gagal menyimpan data: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorSnackBar('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pilihTanggalAmbil() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalAmbil ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedTanggalAmbil = picked;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Tambah Penjualan Bebek', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3A86FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pengguna ID Field
              const Text(
                'ID Pengguna',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3A86FF)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _penggunaIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ID Pengguna',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF3A86FF)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan ID pengguna';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Date Picker
              const Text(
                'Tanggal Input',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3A86FF)),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pilihTanggal,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFF3A86FF)),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMM yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Jumlah Bebek Field
              const Text(
                'Jumlah Bebek',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3A86FF)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah Bebek Terjual',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.pets, color: Color(0xFF3A86FF)),
                  suffix: const Text('ekor'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan jumlah';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  if (int.parse(value) < 1) return 'Jumlah harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Harga Field
              const Text(
                'Harga Penjualan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3A86FF)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Penjualan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF3A86FF)),
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan harga';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  if (int.parse(value) < 0) return 'Harga tidak boleh negatif';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Status Dropdown
              const Text(
                'Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3A86FF)),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.info, color: Color(0xFF3A86FF)),
                ),
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status.toUpperCase()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Tanggal Ambil (Optional)
              const Text(
                'Tanggal Ambil (Opsional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF3A86FF)),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pilihTanggalAmbil,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: Color(0xFF3A86FF)),
                      const SizedBox(width: 12),
                      Text(
                        _selectedTanggalAmbil != null 
                          ? DateFormat('dd MMM yyyy').format(_selectedTanggalAmbil!)
                          : 'Pilih tanggal ambil',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedTanggalAmbil != null ? Colors.black : Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedTanggalAmbil != null)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedTanggalAmbil = null;
                            });
                          },
                          icon: const Icon(Icons.clear, color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _simpanData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A86FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        'Simpan Data',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _hargaController.dispose();
    _penggunaIdController.dispose();
    super.dispose();
  }
}