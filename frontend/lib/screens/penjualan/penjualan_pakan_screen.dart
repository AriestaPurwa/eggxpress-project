import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'form_tambah_pakan.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PenjualanPakanScreen extends StatefulWidget {
  const PenjualanPakanScreen({super.key});

  @override
  State<PenjualanPakanScreen> createState() => _PenjualanPakanScreenState();
}

class _PenjualanPakanScreenState extends State<PenjualanPakanScreen> {
  List<Map<String, dynamic>> dataPenjualan = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('penjualan_pakan');
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      setState(() {
        dataPenjualan = decoded.map((item) {
          DateTime parsedDate;

          try {
            parsedDate = DateTime.parse(item['tanggal']);
          } catch (_) {
            // fallback jika sebelumnya disimpan dalam format dd-MM-yyyy
            parsedDate = DateFormat('dd-MM-yyyy').parse(item['tanggal']);
          }

          return {
            'tanggal': parsedDate,
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
        'tanggal': (item['tanggal'] as DateTime).toIso8601String(),
        'jumlah': item['jumlah'],
        'harga': item['harga'],
      };
    }).toList();
    await prefs.setString('penjualan_pakan', json.encode(dataToSave));
  }

  void _tambahData() async {
    final hasil = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FormTambahPakan(),
    );

    if (hasil != null) {
      setState(() {
        dataPenjualan.insert(0, {
          'tanggal': hasil['tanggal'], // ini sudah DateTime dari form
          'jumlah': hasil['jumlah'],
          'harga': hasil['harga'],
        });
      });
      _saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalKg = dataPenjualan.fold(0, (sum, item) => sum + (item['jumlah'] as int));
    final int totalHarga = dataPenjualan.fold(0, (sum, item) => sum + (item['harga'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A86FF),
        title: const Text('Penjualan Pakan', style: TextStyle(color: Colors.white)),
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
            _buildTotalKeseluruhan(totalKg, totalHarga),
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
          Image.asset('assets/pakan.png', width: 70, height: 70),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ringkasan Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  'Tanggal: ${DateFormat('dd MMM yyyy').format(data['tanggal'])}\nJumlah: ${data['jumlah']} kg\nHarga: Rp${data['harga']}',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('dd MMM yyyy').format(item['tanggal']), style: const TextStyle(fontSize: 16)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${item['jumlah']} kg', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  Text('Rp${item['harga']}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalKeseluruhan(int totalKg, int totalHarga) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Total: $totalKg kg | Rp$totalHarga',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A57)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
