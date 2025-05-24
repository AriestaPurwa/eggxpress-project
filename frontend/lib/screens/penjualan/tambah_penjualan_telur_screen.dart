import 'package:flutter/material.dart';

class TambahPenjualanTelurScreen extends StatefulWidget {
  const TambahPenjualanTelurScreen({super.key});

  @override
  State<TambahPenjualanTelurScreen> createState() => _TambahPenjualanTelurScreenState();
}

class _TambahPenjualanTelurScreenState extends State<TambahPenjualanTelurScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  DateTime? _tanggal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penjualan Telur', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3A86FF),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
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
                subtitle: Text(_tanggal == null
                    ? 'Pilih tanggal'
                    : '${_tanggal!.day}-${_tanggal!.month}-${_tanggal!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      _tanggal = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Jumlah
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Telur (butir)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan jumlah';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Harga total
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Total Harga (Rp)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan total harga';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
                      ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _tanggal != null) {
                    final data = {
                      'tanggal': '${_tanggal!.day}-${_tanggal!.month}-${_tanggal!.year}',
                      'jumlah': int.parse(_jumlahController.text),
                      'total': int.parse(_hargaController.text),
                    };
                    Navigator.pop(context, data); // Kembali dan kirim data
                  } else if (_tanggal == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Silakan pilih tanggal")),
                    );
                  }
                },
                // ... styling tetap
                child: const Text('Simpan', style: TextStyle(color: Color.fromARGB(255, 2, 10, 247))),
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
