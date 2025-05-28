import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormTambahAlat extends StatefulWidget {
  const FormTambahAlat({super.key});

  @override
  State<FormTambahAlat> createState() => _FormTambahAlatState();
}

class _FormTambahAlatState extends State<FormTambahAlat> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaAlatController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  DateTime? _tanggalInput;
  DateTime? _tanggalAmbil;
  String _status = 'diterima'; // Default status
  bool _isLoading = false;

  // Daftar status yang tersedia
  final List<String> _statusOptions = [
    'diterima',
    'pending',
    'ditolak',
    'diproses'
  ];

  @override
  void dispose() {
    _namaAlatController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate() && 
        _tanggalInput != null && 
        _tanggalAmbil != null) {
      setState(() {
        _isLoading = true;
      });

      final dataBaru = {
        'nama_alat': _namaAlatController.text,
        'jumlah_alat': int.parse(_jumlahController.text),
        'tanggal_input': '${_tanggalInput!.year}-${_tanggalInput!.month.toString().padLeft(2, '0')}-${_tanggalInput!.day.toString().padLeft(2, '0')}',
        'tanggal_ambil': '${_tanggalAmbil!.year}-${_tanggalAmbil!.month.toString().padLeft(2, '0')}-${_tanggalAmbil!.day.toString().padLeft(2, '0')}',
        'status': _status,
        'pengguna_id': 2, // Sesuaikan dengan ID pengguna yang login
      };

      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/alat-ternak'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(dataBaru),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          
          if (jsonResponse['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data berhasil disimpan'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Return true untuk reload data
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(jsonResponse['message'] ?? 'Gagal menyimpan data'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          final Map<String, dynamic> errorResponse = jsonDecode(response.body);
          String errorMessage = 'Gagal menyimpan data: ${response.statusCode}';
          
          // Handle validation errors
          if (errorResponse.containsKey('errors')) {
            Map<String, dynamic> errors = errorResponse['errors'];
            List<String> errorMessages = [];
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.addAll(value.cast<String>());
              } else {
                errorMessages.add(value.toString());
              }
            });
            errorMessage = errorMessages.join('\n');
          } else if (errorResponse.containsKey('message')) {
            errorMessage = errorResponse['message'];
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Validasi tanggal
      if (_tanggalInput == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Silakan pilih tanggal input terlebih dahulu"),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (_tanggalAmbil == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Silakan pilih tanggal ambil terlebih dahulu"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text(
          'Tambah Data Alat Ternak',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3A86FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Nama Alat
                  TextFormField(
                    controller: _namaAlatController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Alat',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.build),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan nama alat';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Jumlah Alat
                  TextFormField(
                    controller: _jumlahController,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Alat (item)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan jumlah alat';
                      }
                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'Masukkan jumlah yang valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Tanggal Input
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Tanggal Input'),
                      subtitle: Text(
                        _tanggalInput == null
                            ? 'Pilih tanggal input'
                            : '${_tanggalInput!.day}-${_tanggalInput!.month}-${_tanggalInput!.year}',
                        style: TextStyle(
                          color: _tanggalInput == null ? Colors.grey : Colors.black,
                        ),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setState(() {
                            _tanggalInput = picked;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tanggal Ambil
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      leading: const Icon(Icons.event),
                      title: const Text('Tanggal Ambil'),
                      subtitle: Text(
                        _tanggalAmbil == null
                            ? 'Pilih tanggal ambil'
                            : '${_tanggalAmbil!.day}-${_tanggalAmbil!.month}-${_tanggalAmbil!.year}',
                        style: TextStyle(
                          color: _tanggalAmbil == null ? Colors.grey : Colors.black,
                        ),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _tanggalInput ?? DateTime.now(),
                          firstDate: _tanggalInput ?? DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setState(() {
                            _tanggalAmbil = picked;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status Dropdown
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info),
                    ),
                    items: _statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _status = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 30),

                  // Tombol Simpan
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _simpanData,
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isLoading ? 'Menyimpan...' : 'Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A86FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tombol Batal
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3A86FF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}