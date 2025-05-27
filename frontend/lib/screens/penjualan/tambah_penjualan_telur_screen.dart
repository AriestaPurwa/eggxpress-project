import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TambahPenjualanTelurScreen extends StatefulWidget {
  const TambahPenjualanTelurScreen({super.key});

  @override
  State<TambahPenjualanTelurScreen> createState() => _TambahPenjualanTelurScreenState();
}

class _TambahPenjualanTelurScreenState extends State<TambahPenjualanTelurScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  DateTime? _tanggal;
  DateTime? _tanggalAmbil; // Tambahan untuk tanggal ambil
  String _selectedKualitas = 'bagus';
  String _selectedStatus = 'Tersedia';
  bool _isLoading = false;
  int? _currentUserId;
  String? _currentUserName;

  final String baseUrl = 'http://127.0.0.1:8000/api';

  List<String> kualitasOptions = ['bagus', 'sedang', 'buruk'];
  List<String> statusOptions = ['Tersedia', 'Terjual', 'Rusak', 'Expired'];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Helper method untuk mengambil user_id dengan aman
  Future<int?> _getUserId(SharedPreferences prefs) async {
    try {
      // Coba ambil sebagai String terlebih dahulu (ini yang paling umum terjadi)
      String? userIdString = prefs.getString('user_id');
      if (userIdString != null && userIdString.isNotEmpty) {
        return int.tryParse(userIdString);
      }
      
      // Jika tidak ada sebagai String, coba ambil sebagai int
      return prefs.getInt('user_id');
    } catch (e) {
      print('Error getting user_id: $e');
      return null;
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Gunakan helper method untuk mengambil user_id
      int? userId = await _getUserId(prefs);
      String? userName = prefs.getString('user_name');
      
      print('Loaded user data - ID: $userId, Name: $userName');
      
      if (mounted) {
        setState(() {
          _currentUserId = userId;
          _currentUserName = userName ?? 'User';
        });
        
        if (_currentUserId == null) {
          print('No valid user_id found, redirecting to login');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silakan login terlebih dahulu'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error memuat data user: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate() || _tanggal == null || _currentUserId == null) {
      if (_tanggal == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan pilih tanggal input")),
        );
      }
      if (_currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: User tidak teridentifikasi")),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format tanggal ke format yang diterima API (YYYY-MM-DD)
      String formattedDate = '${_tanggal!.year}-${_tanggal!.month.toString().padLeft(2, '0')}-${_tanggal!.day.toString().padLeft(2, '0')}';
      
      // Format tanggal ambil jika ada
      String? formattedTanggalAmbil;
      if (_tanggalAmbil != null) {
        formattedTanggalAmbil = '${_tanggalAmbil!.year}-${_tanggalAmbil!.month.toString().padLeft(2, '0')}-${_tanggalAmbil!.day.toString().padLeft(2, '0')}';
      }
      
      // Data yang akan dikirim
      Map<String, dynamic> requestData = {
        'pengguna_id': _currentUserId,
        'jumlah_telur': int.parse(_jumlahController.text),
        'kualitas': _selectedKualitas,
        'tanggal_input': formattedDate,
        'status': _selectedStatus,
        'tanggal_ambil': formattedTanggalAmbil, // Kirim tanggal ambil jika ada
      };
      
      print('=== SUBMIT DATA DEBUG ===');
      print('URL: $baseUrl/stok-telur');
      print('Request Data: $requestData');
      print('JSON Body: ${jsonEncode(requestData)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/stok-telur'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);
      print('Parsed Response Data: $responseData');

      if (response.statusCode == 201 && responseData['success'] == true) {
        // Sukses
        print('SUCCESS: Data berhasil disimpan');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Data berhasil disimpan'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Kembali ke halaman sebelumnya dengan data
          Navigator.pop(context, {
            'success': true,
            'data': responseData['data'],
          });
        }
      } else {
        // Error dari server
        print('ERROR: Status code ${response.statusCode}');
        String errorMessage = 'Gagal menyimpan data';
        
        if (responseData != null) {
          if (responseData['message'] != null) {
            errorMessage = responseData['message'];
          } else if (responseData['errors'] != null) {
            // Handle validation errors
            Map<String, dynamic> errors = responseData['errors'];
            List<String> errorMessages = [];
            errors.forEach((field, messages) {
              if (messages is List) {
                errorMessages.addAll(messages.cast<String>());
              } else {
                errorMessages.add(messages.toString());
              }
            });
            errorMessage = errorMessages.join(', ');
          }
        }
        
        print('Final Error Message: $errorMessage');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Error koneksi atau parsing
      print('EXCEPTION in _submitData: $e');
      print('Exception type: ${e.runtimeType}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penjualan Telur', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3A86FF),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Info User yang sedang login
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue.shade600),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login sebagai:',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          _currentUserName ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tanggal Input
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tanggal Input *'),
                subtitle: Text(_tanggal == null
                    ? 'Pilih tanggal input'
                    : '${_tanggal!.day}-${_tanggal!.month}-${_tanggal!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      _tanggal = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Tanggal Ambil (Optional)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tanggal Ambil (Opsional)'),
                subtitle: Text(_tanggalAmbil == null
                    ? 'Pilih tanggal ambil (opsional)'
                    : '${_tanggalAmbil!.day}-${_tanggalAmbil!.month}-${_tanggalAmbil!.year}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_tanggalAmbil != null)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _tanggalAmbil = null;
                          });
                        },
                      ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _tanggalAmbil ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      _tanggalAmbil = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Jumlah Telur
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Telur (butir)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan jumlah telur';
                  int? jumlah = int.tryParse(value);
                  if (jumlah == null || jumlah < 1) return 'Jumlah harus minimal 1';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Kualitas Dropdown
              DropdownButtonFormField<String>(
                value: _selectedKualitas,
                decoration: const InputDecoration(
                  labelText: 'Kualitas Telur',
                  border: OutlineInputBorder(),
                ),
                items: kualitasOptions.map((String kualitas) {
                  return DropdownMenuItem<String>(
                    value: kualitas,
                    child: Text(kualitas.toUpperCase()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKualitas = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Pilih kualitas';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Pilih status';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Total Harga (Optional - untuk informasi saja)
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Total Harga (Rp) - Opsional',
                  border: OutlineInputBorder(),
                  helperText: 'Field ini tidak dikirim ke API, hanya untuk catatan',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              // Info tentang field yang wajib
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade600, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Field dengan tanda (*) wajib diisi',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _isLoading ? null : _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A86FF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
              const SizedBox(height: 10),

              // Tombol Batal
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}