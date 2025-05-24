import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormTambahAlat extends StatefulWidget {
  const FormTambahAlat({super.key});

  @override
  State<FormTambahAlat> createState() => _FormTambahAlatState();
}

class _FormTambahAlatState extends State<FormTambahAlat> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  DateTime? _tanggal;

  @override
  void dispose() {
    _jumlahController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate() && _tanggal != null) {
      final dataBaru = {
        'tanggal': '${_tanggal!.day}-${_tanggal!.month}-${_tanggal!.year}',
        'jumlah': int.parse(_jumlahController.text),
        'harga': int.parse(_hargaController.text),
      };

      final prefs = await SharedPreferences.getInstance();
      final String? existingData = prefs.getString('penjualan_alat');
      List<dynamic> dataList = [];

      if (existingData != null) {
        dataList = jsonDecode(existingData);
      }

      dataList.add(dataBaru);
      await prefs.setString('penjualan_alat', jsonEncode(dataList));

      Navigator.pop(context, dataBaru);
    } else if (_tanggal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih tanggal terlebih dahulu")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Tambah Penjualan Alat', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3A86FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Tanggal
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tanggal Penjualan'),
                subtitle: Text(
                  _tanggal == null
                      ? 'Pilih tanggal'
                      : '${_tanggal!.day}-${_tanggal!.month}-${_tanggal!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) {
                    setState(() {
                      _tanggal = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Jumlah Alat
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Alat (item)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah alat';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Harga Alat
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Total Harga (Rp)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan total harga';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3A86FF),
                  side: const BorderSide(color: Color(0xFF3A86FF)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Simpan'),
              ),
              const SizedBox(height: 10),

              // Tombol Batal
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
