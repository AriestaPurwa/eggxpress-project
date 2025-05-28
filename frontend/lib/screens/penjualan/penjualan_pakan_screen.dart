import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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
  bool isLoading = false;
  String? baseUrl;
  String? authToken;

  @override
  void initState() {
    super.initState();
    _initializeConfig();
  }

  Future<void> _initializeConfig() async {
    final prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString('api_base_url') ?? 'http://localhost:8000';
    authToken = prefs.getString('auth_token');
    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    
    try {
      // Try to load from API first
      await _loadFromAPI();
    } catch (e) {
      // Fallback to local storage if API fails
      print('API failed, loading from local storage: $e');
      await _loadFromLocal();
    }
    
    setState(() => isLoading = false);
  }

  Future<void> _loadFromAPI() async {
    if (baseUrl == null) throw Exception('Base URL not configured');
    
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/stok-pakan'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List apiData = responseData['data'] ?? responseData;
      
      setState(() {
        dataPenjualan = apiData.map((item) {
          DateTime parsedDate;
          
          try {
            // Try parsing ISO format first
            parsedDate = DateTime.parse(item['tanggal'] ?? item['created_at']);
          } catch (_) {
            try {
              // Fallback to dd-MM-yyyy format
              parsedDate = DateFormat('dd-MM-yyyy').parse(item['tanggal']);
            } catch (_) {
              // Final fallback to current date
              parsedDate = DateTime.now();
            }
          }

          return {
            'id': item['id'],
            'tanggal': parsedDate,
            'jumlah': int.tryParse(item['jumlah_kg']?.toString() ?? item['jumlah']?.toString() ?? '0') ?? 0,
            'harga': int.tryParse(item['harga_per_kg']?.toString() ?? item['harga']?.toString() ?? '0') ?? 0,
            'nama_pakan': item['nama_pakan'] ?? 'Pakan',
            'pengguna_id': item['pengguna_id'],
          };
        }).toList();
      });
      
      // Save to local storage as backup
      await _saveToLocal();
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> _loadFromLocal() async {
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
            parsedDate = DateFormat('dd-MM-yyyy').parse(item['tanggal']);
          }

          return {
            'id': item['id'],
            'tanggal': parsedDate,
            'jumlah': item['jumlah'],
            'harga': item['harga'],
            'nama_pakan': item['nama_pakan'] ?? 'Pakan',
            'pengguna_id': item['pengguna_id'],
          };
        }).toList();
      });
    }
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dataToSave = dataPenjualan.map((item) {
      return {
        'id': item['id'],
        'tanggal': (item['tanggal'] as DateTime).toIso8601String(),
        'jumlah': item['jumlah'],
        'harga': item['harga'],
        'nama_pakan': item['nama_pakan'],
        'pengguna_id': item['pengguna_id'],
      };
    }).toList();
    await prefs.setString('penjualan_pakan', json.encode(dataToSave));
  }

  Future<Map<String, dynamic>> _saveToAPI(Map<String, dynamic> data) async {
  if (baseUrl == null) throw Exception('Base URL not configured');
  
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  if (authToken != null) {
    headers['Authorization'] = 'Bearer $authToken';
  }

  final requestBody = {
    'nama_pakan': data['nama_pakan'],
    'jumlah_kg': data['jumlah'],
    'harga_per_kg': data['harga'],
    'tanggal': (data['tanggal'] as DateTime).toIso8601String(),
    'pengguna_id': data['pengguna_id'],
  };

  final response = await http.post(
    Uri.parse('$baseUrl/api/stok-pakan'),
    headers: headers,
    body: json.encode(requestBody),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to save data: ${response.statusCode}');
  }

  return json.decode(response.body); // ✅ Sekarang akan dikembalikan dengan benar
}

  void _tambahData() async {
    final hasil = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FormTambahPakan(),
    );

    if (hasil != null) {
      setState(() => isLoading = true);
      
      try {
        // Save to API first
        final savedData = await _saveToAPI(hasil);
        
        setState(() {
          dataPenjualan.insert(0, {
           'id': (savedData['data']?['id'])?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
            'tanggal': hasil['tanggal'],
            'jumlah': hasil['jumlah'],
            'harga': hasil['harga'],
            'nama_pakan': hasil['nama_pakan'],
            'pengguna_id': hasil['pengguna_id'],
          });
        });
        
        // Save to local storage as backup
        await _saveToLocal();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil disimpan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        // Fallback to local storage only
        setState(() {
          dataPenjualan.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch,
            'tanggal': hasil['tanggal'],
            'jumlah': hasil['jumlah'],
            'harga': hasil['harga'],
            'nama_pakan': hasil['nama_pakan'],
            'pengguna_id': hasil['pengguna_id'],
          });
        });
        await _saveToLocal();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data disimpan lokal (API error: $e)'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
      
      setState(() => isLoading = false);
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                  'Tanggal: ${DateFormat('dd MMM yyyy').format(data['tanggal'])}\n'
                  'Pakan: ${data['nama_pakan']}\n'
                  'Jumlah: ${data['jumlah']} kg\n'
                  'Harga: Rp${data['harga']}',
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
    if (dataPenjualan.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada data penjualan', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(item['tanggal']), 
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['nama_pakan'] ?? 'Pakan', 
                      style: const TextStyle(fontSize: 14, color: Colors.grey)
                    ),
                  ],
                ),
              ),
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