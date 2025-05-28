import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormTambahPakan extends StatefulWidget {
  const FormTambahPakan({super.key});

  @override
  State<FormTambahPakan> createState() => _FormTambahPakanState();
}

class _FormTambahPakanState extends State<FormTambahPakan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _namaPakanController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  DateTime? _selectedDate;
  int? _penggunaId;

  // Predefined feed types
  final List<String> _jenisPakan = [
    'Pelet Ikan',
    'dedek',
    'katul'

  ];

  String? _selectedJenisPakan;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _penggunaId = prefs.getInt('user_id') ?? prefs.getInt('pengguna_id') ?? 1;
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _namaPakanController.dispose();
    _jumlahController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final String namaPakan = _selectedJenisPakan ?? _namaPakanController.text;
      
      Navigator.pop(context, {
        'tanggal': _selectedDate!,
        'nama_pakan': namaPakan,
        'jumlah': int.parse(_jumlahController.text),
        'harga': int.parse(_hargaController.text),
        'pengguna_id': _penggunaId ?? 1,
      });
    }
  }

  void _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penjualan Pakan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3A86FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Date Field
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Pilih tanggal';
                  if (_selectedDate == null) return 'Tanggal tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Feed Type Selection
              DropdownButtonFormField<String>(
                value: _selectedJenisPakan,
                decoration: const InputDecoration(
                  labelText: 'Jenis Pakan',
                  prefixIcon: Icon(Icons.restaurant),
                  border: OutlineInputBorder(),
                ),
                items: [
                  ..._jenisPakan.map((jenis) => DropdownMenuItem(
                    value: jenis,
                    child: Text(jenis),
                  )),
                  const DropdownMenuItem(
                    value: 'custom',
                    child: Text('Lainnya (Isi Manual)'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedJenisPakan = value;
                    if (value != 'custom') {
                      _namaPakanController.clear();
                    }
                  });
                },
                validator: (value) {
                  if (value == null) return 'Pilih jenis pakan';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Custom Feed Name (Only shown when "Lainnya" is selected)
              if (_selectedJenisPakan == 'custom') ...[
                TextFormField(
                  controller: _namaPakanController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pakan Custom',
                    prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan nama pakan',
                  ),
                  validator: (value) {
                    if (_selectedJenisPakan == 'custom' && (value == null || value.isEmpty)) {
                      return 'Masukkan nama pakan';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Quantity Field
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Pakan (kg)',
                  prefixIcon: Icon(Icons.scale),
                  border: OutlineInputBorder(),
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan jumlah pakan';
                  final number = int.tryParse(value);
                  if (number == null) return 'Masukkan angka yang valid';
                  if (number <= 0) return 'Jumlah harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga per kg (Rp)',
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan harga';
                  final number = int.tryParse(value);
                  if (number == null) return 'Masukkan angka yang valid';
                  if (number <= 0) return 'Harga harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Summary Card
              if (_jumlahController.text.isNotEmpty && _hargaController.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3A86FF).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringkasan:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text('Jenis: ${_selectedJenisPakan == 'custom' ? _namaPakanController.text : _selectedJenisPakan ?? '-'}'),
                      Text('Jumlah: ${_jumlahController.text} kg'),
                      Text('Harga per kg: Rp ${_hargaController.text}'),
                      const Divider(),
                      Text(
                        'Total: Rp ${_calculateTotal()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A86FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTotal() {
    final jumlah = int.tryParse(_jumlahController.text) ?? 0;
    final harga = int.tryParse(_hargaController.text) ?? 0;
    final total = jumlah * harga;
    return NumberFormat('#,###').format(total);
  }
}