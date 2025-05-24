import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'penjualanTelurScreen.dart';
import 'penjualan_bebek_screen.dart';
import 'penjualan_pakan_screen.dart';
import 'penjualan_alat_screen.dart';
 // Pastikan untuk mengimpor file ini

class PenjualanScreen extends StatelessWidget {
  const PenjualanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF), // Biru sangat muda
      appBar: AppBar(
        title: const Text(
          'Kategori Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4361EE), // Biru indigo terang
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Kategori:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A0CA3), // Biru tua
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildCard(
                    icon: LucideIcons.egg,
                    label: "Penjualan Telur",
                    color: const Color(0xFFD0E1FF),
                    iconColor: const Color(0xFF4361EE),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PenjualanTelurScreen(), // Buat halaman ini terpisah
                    ));
                    },
                  ),
                  _buildCard(
                    icon: LucideIcons.feather,
                    label: "Penjualan Bebek",
                    color: const Color(0xFFBFD7FF),
                    iconColor: const Color(0xFF3A86FF),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PenjualanBebekScreen(), // Buat halaman ini terpisah
                    ));
                    },
                  ),
                  _buildCard(
                    icon: LucideIcons.wheat,
                    label: "Penjualan Pakan",
                    color: const Color(0xFFA6C8FF),
                    iconColor: const Color(0xFF4895EF),
                    onTap: () {Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PenjualanPakanScreen(), // Buat halaman ini terpisah
                     )); 
                    },
                  ),
                  _buildCard(
                    icon: LucideIcons.wrench,
                    label: "Penjualan Alat",
                    color: const Color(0xFF9EB7FF),
                    iconColor: const Color(0xFF3F37C9),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PenjualanAlatScreen(), // Buat halaman ini terpisah
                    ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: iconColor),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }
}
