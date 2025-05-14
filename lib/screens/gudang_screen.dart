import 'package:flutter/material.dart';
import '../widgets/inventory_card.dart';
import '../widgets/bottom_nav_bar.dart';

class GudangScreen extends StatelessWidget {
  const GudangScreen({Key? key}) : super(key: key);

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
              // Header section
              Container(
                padding: const EdgeInsets.fromLTRB(23, 9, 11, 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9E4FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'halo, pedagang',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.52,
                        color: Colors.black,
                      ),
                    ),
                    Image.network(
                      'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/1cffee74341d4d275f5c34cb38d7f6b38defa0b2?placeholderIfAbsent=true',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Title and Add Data button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gudang',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.52,
                      color: const Color(0xFF202020),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 21,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004CFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Tambah Data',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFFF3F3F3),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Inventory Cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InventoryCard(
                        title: 'STOCK TELUR',
                        description: '9 APRIL 2025 : 200 BUTIR',
                        imageUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/c0f0d836a2bd2ef39df5c0bc24bfc50d4ce5f6f7?placeholderIfAbsent=true',
                        arrowUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/6d4c550759df2ef796953a2af20dfcd4fb6d6161?placeholderIfAbsent=true',
                      ),
                      const SizedBox(height: 23),
                      InventoryCard(
                        title: 'STOCK BEBEK',
                        description: '9 APRIL 2025 : 200 EKOR',
                        imageUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/c0f0d836a2bd2ef39df5c0bc24bfc50d4ce5f6f7?placeholderIfAbsent=true',
                        arrowUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/6d4c550759df2ef796953a2af20dfcd4fb6d6161?placeholderIfAbsent=true',
                      ),
                      const SizedBox(height: 23),
                      InventoryCard(
                        title: 'STOCK PAKAN',
                        description: '9 APRIL 2025 : 200 BUAH',
                        imageUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/c0f0d836a2bd2ef39df5c0bc24bfc50d4ce5f6f7?placeholderIfAbsent=true',
                        arrowUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/6d4c550759df2ef796953a2af20dfcd4fb6d6161?placeholderIfAbsent=true',
                      ),
                      const SizedBox(height: 24),
                      InventoryCard(
                        title: 'STOCK ALAT',
                        description: '9 APRIL 2025 : 200 UNIT',
                        imageUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/c0f0d836a2bd2ef39df5c0bc24bfc50d4ce5f6f7?placeholderIfAbsent=true',
                        arrowUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/6d4c550759df2ef796953a2af20dfcd4fb6d6161?placeholderIfAbsent=true',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 29),

              // Bottom Navigation
              const BottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}
