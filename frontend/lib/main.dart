import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/penjualan/penjualan_bebek_screen.dart';
import 'screens/penjualan/tambah_penjualan_bebek_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      routes: {
        '/penjualanBebek': (context) => const PenjualanBebekScreen(),
        '/tambahBebek': (context) => const TambahPenjualanBebekScreen(),
      },
    );
  }
}
