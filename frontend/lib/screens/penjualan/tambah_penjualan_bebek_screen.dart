import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambahPenjualanBebekScreen extends StatefulWidget {
  const TambahPenjualanBebekScreen({super.key});

  @override
  State<TambahPenjualanBebekScreen> createState() => _TambahPenjualanBebekScreenState();
}

class _TambahPenjualanBebekScreenState extends State<TambahPenjualanBebekScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _hargaController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'tanggal': DateFormat('dd-MM-yyyy').format(_selectedDate),
        'jumlah': int.parse(_jumlahController.text),
        'harga': int.parse(_hargaController.text),
      });
    }
  }

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penjualan Bebek', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3A86FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF3A86FF)),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _pilihTanggal,
                    child: Text(
                      DateFormat('dd MMM yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Bebek Terjual',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan jumlah';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Penjualan (Rp)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan harga';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A86FF),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Simpan', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
