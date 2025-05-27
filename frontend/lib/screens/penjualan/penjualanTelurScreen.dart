import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'tambah_penjualan_telur_screen.dart';

class PenjualanTelurScreen extends StatefulWidget {
  const PenjualanTelurScreen({super.key});

  @override
  State<PenjualanTelurScreen> createState() => _PenjualanTelurScreenState();
}

class _PenjualanTelurScreenState extends State<PenjualanTelurScreen> {
  List<Map<String, dynamic>> _dataPenjualan = [];
  bool _isLoading = false;
  final String _baseUrl = 'http://127.0.0.1:8000/api';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/stok-telur'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> apiData = responseData['data'];
          
          // Transform API data to match existing UI structure
          setState(() {
            _dataPenjualan = apiData.map((item) {
              return {
                'id': item['id'],
                'tanggal': item['tanggal_input'],
                'jumlah': item['jumlah_telur'],
                'total': item['jumlah_telur'] * 3000, // Assume price per egg is 2500
                'kualitas': item['kualitas'],
                'status': item['status'],
                'pengguna': item['pengguna'],
              };
            }).toList();
          });
        } else {
          _showErrorSnackBar('Gagal memuat data: ${responseData['message']}');
        }
      } else {
        _showErrorSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addPenjualan(Map<String, dynamic> newData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/stok-telur'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'pengguna_id': newData['pengguna_id'] ?? 1, // Default pengguna_id
          'jumlah_telur': newData['jumlah'],
          'kualitas': newData['kualitas'] ?? 'A',
          'tanggal_input': newData['tanggal'],
          'status': newData['status'] ?? 'Tersedia',
          'tanggal_ambil': null,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true) {
          _showSuccessSnackBar('Data berhasil ditambahkan');
          await _loadData(); // Reload data from API
        } else {
          _showErrorSnackBar('Gagal menambah data: ${responseData['message']}');
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        _showErrorSnackBar('Error: ${errorData['message'] ?? 'Terjadi kesalahan'}');
      }
    } catch (e) {
      _showErrorSnackBar('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePenjualan(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/stok-telur/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true) {
          _showSuccessSnackBar('Data berhasil dihapus');
          await _loadData(); // Reload data from API
        } else {
          _showErrorSnackBar('Gagal menghapus data: ${responseData['message']}');
        }
      } else {
        _showErrorSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteConfirmation(int id, String tanggal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data penjualan tanggal $tanggal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePenjualan(id);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalButir =
        _dataPenjualan.fold<int>(0, (sum, item) => sum + (item['jumlah'] as int));
    final int totalHarga =
        _dataPenjualan.fold<int>(0, (sum, item) => sum + (item['total'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A86FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Penjualan Telur',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A86FF)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_dataPenjualan.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6E4FF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.egg, size: 48, color: Color(0xFF3A86FF)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ringkasan Terakhir',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1B3A57),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tanggal: ${_dataPenjualan[0]['tanggal']}\n'
                                  'Jumlah: ${_dataPenjualan[0]['jumlah']} butir\n'
                                  'Kualitas: ${_dataPenjualan[0]['kualitas']}\n'
                                  'Total: Rp ${_dataPenjualan[0]['total']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF3A3A3A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 30),

                  Row(
                    children: const [
                      Icon(Icons.list_alt, color: Color(0xFF3A86FF)),
                      SizedBox(width: 8),
                      Text(
                        'Riwayat Penjualan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A86FF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: _dataPenjualan.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Belum ada data penjualan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _dataPenjualan.length,
                            itemBuilder: (context, index) {
                              final data = _dataPenjualan[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.12),
                                      blurRadius: 6,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['tanggal'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${data['jumlah']} butir • Kualitas ${data['kualitas']}',
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          if (data['status'] != null)
                                            Text(
                                              'Status: ${data['status']}',
                                              style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Rp ${data['total'].toString()}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                                          onPressed: () => _showDeleteConfirmation(
                                            data['id'],
                                            data['tanggal'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6E4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Total Keseluruhan: $totalButir butir • Rp $totalHarga',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B3A57),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TambahPenjualanTelurScreen(),
                              ),
                            );
                            if (result != null && result is Map<String, dynamic>) {
                              await _addPenjualan(result);
                            }
                          },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Penjualan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A86FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}