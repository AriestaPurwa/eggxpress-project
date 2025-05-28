import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/inventory_card.dart';
import 'edit_gudang_screen.dart';

class GudangScreen extends StatefulWidget {
  const GudangScreen({super.key});

  @override
  State<GudangScreen> createState() => _GudangScreenState();
}

class _GudangScreenState extends State<GudangScreen> {
  Map<String, int> stokData = {};
  bool isLoading = true;
  String? errorMessage;
  
  // Ganti dengan base URL API Anda
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  @override
  void initState() {
    super.initState();
    loadStokData();
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<int> fetchStokTelur() async {
    try {
      final userId = await getUserId();
      final headers = await getHeaders();
      String url = userId != null 
          ? '$baseUrl/stok-telur/pengguna/$userId'
          : '$baseUrl/stok-telur/total/telur';
      
      final response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (userId != null) {
          // Jika mengambil data per pengguna, hitung total dari array
          final List<dynamic> stokList = data['data'] ?? [];
          return stokList.fold<int>(0, (sum, item) => sum + (item['jumlah'] as int? ?? 0));
        } else {
          // Jika mengambil total langsung
          return data['total'] ?? 0;
        }
      }
      return 0;
    } catch (e) {
      print('Error fetching stok telur: $e');
      return 0;
    }
  }

  Future<int> fetchStokBebek() async {
    try {
      final userId = await getUserId();
      final headers = await getHeaders();
      String url = userId != null 
          ? '$baseUrl/data-bebek/pengguna/$userId'
          : '$baseUrl/data-bebek/total/bebek';
      
      final response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (userId != null) {
          // Jika mengambil data per pengguna, hitung total dari array
          final List<dynamic> bebekList = data['data'] ?? [];
          return bebekList.fold<int>(0, (sum, item) => sum + (item['jumlah'] as int? ?? 0));
        } else {
          // Jika mengambil total langsung
          return data['total'] ?? 0;
        }
      }
      return 0;
    } catch (e) {
      print('Error fetching stok bebek: $e');
      return 0;
    }
  }

  Future<int> fetchStokPakan() async {
    try {
      final userId = await getUserId();
      final headers = await getHeaders();
      String url = userId != null 
          ? '$baseUrl/stok-pakan/pengguna/$userId'
          : '$baseUrl/stok-pakan/total/stok';
      
      final response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (userId != null) {
          // Jika mengambil data per pengguna, hitung total dari array
          final List<dynamic> pakanList = data['data'] ?? [];
          return pakanList.fold<int>(0, (sum, item) => sum + (item['jumlah'] as int? ?? 0));
        } else {
          // Jika mengambil total langsung
          return data['total'] ?? 0;
        }
      }
      return 0;
    } catch (e) {
      print('Error fetching stok pakan: $e');
      return 0;
    }
  }

  Future<int> fetchStokAlat() async {
    try {
      final userId = await getUserId();
      final headers = await getHeaders();
      String url = userId != null 
          ? '$baseUrl/alat-ternak/pengguna/$userId'
          : '$baseUrl/alat-ternak';
      
      final response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> alatList = data['data'] ?? [];
        return alatList.fold<int>(0, (sum, item) => sum + (item['jumlah'] as int? ?? 0));
      }
      return 0;
    } catch (e) {
      print('Error fetching stok alat: $e');
      return 0;
    }
  }

  Future<void> loadStokData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch semua data secara paralel
      final results = await Future.wait([
        fetchStokTelur(),
        fetchStokBebek(),
        fetchStokPakan(),
        fetchStokAlat(),
      ]);

      setState(() {
        stokData = {
          'telur': results[0],
          'bebek': results[1],
          'pakan': results[2],
          'alat': results[3],
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data: $e';
        isLoading = false;
      });
      print('Error loading stok data: $e');
    }
  }

  Widget buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat data gudang...'),
        ],
      ),
    );
  }

  Widget buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            errorMessage ?? 'Terjadi kesalahan',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loadStokData,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 29),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gudang', 
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => const EditGudangScreen())
                      );
                      loadStokData(); // refresh setelah kembali
                    },
                    child: const Text('Tambah Data'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Content
              Expanded(
                child: isLoading 
                    ? buildLoadingState()
                    : errorMessage != null 
                        ? buildErrorState()
                        : RefreshIndicator(
                            onRefresh: loadStokData,
                            child: ListView(
                              children: stokData.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InventoryCard(
                                    title: 'STOK ${entry.key.toUpperCase()}',
                                    description: 'Jumlah: ${entry.value}',
                                    imageUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/c0f0d836a2bd2ef39df5c0bc24bfc50d4ce5f6f7?placeholderIfAbsent=true',
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}