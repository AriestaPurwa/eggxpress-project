import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'form_tambah_alat.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PenjualanAlatScreen extends StatefulWidget {
  const PenjualanAlatScreen({super.key});

  @override
  State<PenjualanAlatScreen> createState() => _PenjualanAlatScreenState();
}

class _PenjualanAlatScreenState extends State<PenjualanAlatScreen> {
  List<Map<String, dynamic>> _dataAlat = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString('penjualan_alat');
    if (dataString != null) {
      final List<dynamic> jsonData = jsonDecode(dataString);
      setState(() {
        _dataAlat = jsonData.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = jsonEncode(_dataAlat);
    await prefs.setString('penjualan_alat', dataString);
  }

  @override
  Widget build(BuildContext context) {
    final int totalItem = _dataAlat.fold<int>(0, (sum, item) => sum + (item['jumlah'] as int));
    final int totalHarga = _dataAlat.fold<int>(0, (sum, item) => sum + (item['harga'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A86FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Penjualan Alat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_dataAlat.isNotEmpty)
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
                    const Icon(Icons.build, size: 48, color: Color(0xFF3A86FF)),
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
                            'Tanggal: ${_dataAlat[0]['tanggal']}\n'
                            'Jumlah: ${_dataAlat[0]['jumlah']} item\n'
                            'Total: Rp ${_dataAlat[0]['harga']}',
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
              child: ListView.builder(
                itemCount: _dataAlat.length,
                itemBuilder: (context, index) {
                  final data = _dataAlat[index];
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
                        Column(
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
                              '${data['jumlah']} item',
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Rp ${data['harga']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
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
                'Total Keseluruhan: $totalItem item • Rp $totalHarga',
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
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormTambahAlat()),
                );
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _dataAlat.insert(0, result);
                  });
                  await _saveData();
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
