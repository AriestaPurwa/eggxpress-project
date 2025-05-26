import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      appBar: AppBar(
        title: const Text("Informasi Aplikasi"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Ilustrasi atau gambar
          Center(
            child: Image.asset(
              'assets/info.png',
              height: 180,
            ),
          ),
          const SizedBox(height: 24),

          // Kartu informasi
          _InfoCard(
            icon: LucideIcons.badgeDollarSign,
            title: "Fungsi Aplikasi",
            description:
                "Aplikasi ini membantu mencatat dan memantau penjualan telur, bebek, pakan, dan alat secara praktis.",
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: LucideIcons.barChart2,
            title: "Visualisasi Data",
            description:
                "Grafik interaktif menampilkan rekap penjualan bulanan untuk membantu pengambilan keputusan.",
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: LucideIcons.folderLock,
            title: "Penyimpanan Data",
            description:
                "Semua data disimpan secara lokal di perangkat menggunakan SharedPreferences.",
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.indigo),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
