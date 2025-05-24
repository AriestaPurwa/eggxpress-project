import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PenjualanBebekScreen extends StatefulWidget {
  const PenjualanBebekScreen({super.key});

  @override
  State<PenjualanBebekScreen> createState() => _PenjualanBebekScreenState();
}

class _PenjualanBebekScreenState extends State<PenjualanBebekScreen> {
  List<Map<String, dynamic>> dataPenjualan = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('penjualan_bebek');
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      setState(() {
        dataPenjualan = decoded.map((item) {
          return {
            'tanggal': DateTime.parse(item['tanggal']),
            'jumlah': item['jumlah'],
            'harga': item['harga'],
          };
        }).toList();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dataToSave = dataPenjualan.map((item) {
      return {
        'tanggal': item['tanggal'].toIso8601String(),
        'jumlah': item['jumlah'],
        'harga': item['harga'],
      };
    }).toList();
    await prefs.setString('penjualan_bebek', json.encode(dataToSave));
  }

  void _tambahData() async {
    final hasil = await Navigator.pushNamed(context, '/tambahBebek');
    if (hasil != null && hasil is Map<String, dynamic>) {
      setState(() {
        dataPenjualan.insert(0, {
          'tanggal': DateFormat('dd-MM-yyyy').parse(hasil['tanggal']),
          'jumlah': hasil['jumlah'],
          'harga': hasil['harga'],
        });
      });
      _saveData();
    }
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (dataPenjualan.isNotEmpty) _buildRingkasan(dataPenjualan.first),
            const SizedBox(height: 20),
            _buildRiwayatLabel(),
            const SizedBox(height: 10),
            Expanded(child: _buildListView()),
            const SizedBox(height: 8),
            _buildTotalKeseluruhan(totalJumlah, totalHarga),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _tambahData,
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
    );
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
          Image.asset('assets/bebek.png', width: 70, height: 70),
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
                  'Harga: Rp ${data['harga']}',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd MMM yyyy').format(item['tanggal']), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Jumlah: ${item['jumlah']} ekor'),
              Text('Harga: Rp ${item['harga']}'),
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
            'Total Harga: Rp $totalHarga',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A57)),
          ),
        ],
      ),
    );
  }
}
