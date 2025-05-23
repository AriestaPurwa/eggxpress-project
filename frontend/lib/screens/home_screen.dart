import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'gudang_screen.dart';
import 'profile_screen.dart';
import 'penjualan/penjualan_screen.dart'; // <-- Sudah ditambahkan

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    const GudangScreen(),   // Index 0
    const HomeContent(),    // Index 1 (Home)
    const ProfileScreen(),  // Index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.category), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("halo, pedagang",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 4),
                      Text("penjualan minggu ini",
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/avatar.png'),
                )
              ],
            ),

            const SizedBox(height: 20),

            // Chart Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEBFF),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Expenses",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const Text("\$4200.30",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(10, (index) {
                        final height = (index % 5 + 3) * 8.0;
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0xFF9B8BFF),
                                    Color(0xFFEDEBFF),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MenuButton(
                  icon: LucideIcons.badgeDollarSign,
                  label: "Penjualan",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PenjualanScreen(),
                      ),
                    );
                  },
                ),
                _MenuButton(
                  icon: LucideIcons.info,
                  label: "Info",
                  onTap: () {
                    // Tambahkan navigasi ke InfoScreen jika ada
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFEDEBFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.black),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
