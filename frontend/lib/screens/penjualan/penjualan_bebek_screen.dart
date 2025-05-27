import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PenjualanBebekScreen extends StatefulWidget {
  const PenjualanBebekScreen({super.key});

  @override
  State<PenjualanBebekScreen> createState() => _PenjualanBebekScreenState();
}

class _PenjualanBebekScreenState extends State<PenjualanBebekScreen> {
  List<Map<String, dynamic>> dataPenjualan = [];
  bool isLoading = false;
  static const String baseUrl = 'http://127.0.0.1:8000/api/data-bebek';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'];
          setState(() {
            dataPenjualan = data.map((item) {
              return {
                'id': item['id'],
                'tanggal': DateTime.parse(item['tanggal_input']),
                'jumlah': item['jumlah_bebek'],
                'harga': item['harga'] ?? 0, // Assuming harga field exists in API
                'status': item['status'],
                'pengguna_id': item['pengguna_id'],
              };
            }).toList();
            
            // Sort by date descending (newest first)
            dataPenjualan.sort((a, b) => b['tanggal'].compareTo(a['tanggal']));
          });
        }
      } else {
        _showErrorSnackBar('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _tambahData() async {
    final hasil = await Navigator.pushNamed(context, '/tambahBebek');
    if (hasil != null && hasil is Map<String, dynamic>) {
      // Refresh data after adding new item
      _loadData();
    }
  }

  Future<void> _deleteData(int id, int index) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          dataPenjualan.removeAt(index);
        });
        _showSuccessSnackBar('Data berhasil dihapus');
      } else {
        _showErrorSnackBar('Gagal menghapus data');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  void _showDeleteConfirmation(int id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteData(id, index);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
    final int totalJumlah = dataPenjualan.fold(0, (sum, item) => sum + (item['jumlah'] as int));
    final int totalHarga = dataPenjualan.fold(0, (sum, item) => sum + (item['harga'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Penjualan Bebek', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3A86FF),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (dataPenjualan.isNotEmpty && !isLoading) _buildRingkasan(dataPenjualan.first),
              const SizedBox(height: 20),
              _buildRiwayatLabel(),
              const SizedBox(height: 10),
              Expanded(child: _buildContent()),
              const SizedBox(height: 8),
              if (!isLoading) _buildTotalKeseluruhan(totalJumlah, totalHarga),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _tambahData,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Penjualan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A86FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A86FF)),
        ),
      );
    }

    if (dataPenjualan.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Belum ada data penjualan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _buildListView();
  }

  Widget _buildRingkasan(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD6E4FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Replace with network image or local asset
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF3A86FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.pets, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ringkasan Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  'Tanggal: ${DateFormat('dd MMM yyyy').format(data['tanggal'])}\n'
                  'Jumlah: ${data['jumlah']} ekor\n'
                  'Harga: Rp ${NumberFormat('#,###').format(data['harga'])}\n'
                  'Status: ${data['status']}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatLabel() {
    return Row(
      children: const [
        Icon(Icons.list_alt, color: Color(0xFF3A86FF)),
        SizedBox(width: 8),
        Text('Riwayat Penjualan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3A86FF))),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: dataPenjualan.length,
      itemBuilder: (context, index) {
        final item = dataPenjualan[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.12), blurRadius: 6)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(item['tanggal']), 
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 4),
                    Text('Jumlah: ${item['jumlah']} ekor'),
                    Text('Harga: Rp ${NumberFormat('#,###').format(item['harga'])}'),
                    Text('Status: ${item['status']}', 
                      style: TextStyle(
                        color: item['status'] == 'selesai' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmation(item['id'], index),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalKeseluruhan(int totalJumlah, int totalHarga) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Total Jumlah: $totalJumlah ekor',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A57)),
          ),
          const SizedBox(height: 6),
          Text(
            'Total Harga: Rp ${NumberFormat('#,###').format(totalHarga)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A57)),
          ),
        ],
      ),
    );
  }
}