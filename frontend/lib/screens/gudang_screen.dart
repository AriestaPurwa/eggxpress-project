import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    loadStokData();
  }

  Future<void> loadStokData() async {
    final prefs = await SharedPreferences.getInstance();
    final jenisList = ['telur', 'bebek', 'pakan', 'alat'];

    final Map<String, int> data = {};
    for (var jenis in jenisList) {
      data[jenis] = prefs.getInt('stok_$jenis') ?? 0;
    }

    setState(() {
      stokData = data;
    });
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
              // Header, Title and Add button tetap sama
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gudang', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditGudangScreen()));
                      loadStokData(); // refresh setelah kembali
                    },
                    child: const Text('Tambah Data'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: stokData.entries.map((entry) {
                    return InventoryCard(
                      title: 'STOK ${entry.key.toUpperCase()}',
                      description: 'Jumlah: ${entry.value}',
                      imageUrl:
                        'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/c0f0d836a2bd2ef39df5c0bc24bfc50d4ce5f6f7?placeholderIfAbsent=true',
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}