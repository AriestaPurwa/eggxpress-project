import 'package:flutter/material.dart';
import '../widgets/inventory_card.dart';

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
                    const Text(
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
                  const Text(
                    'Gudang',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.52,
                      color: Color(0xFF202020),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Tambah data action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004CFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      'Tambah Data',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Inventory Cards with Edit buttons
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildInventoryCard(
                        context,
                        title: 'STOCK TELUR',
                        description: '9 APRIL 2025 : 200 BUTIR',
                      ),
                      buildInventoryCard(
                        context,
                        title: 'STOCK BEBEK',
                        description: '9 APRIL 2025 : 200 EKOR',
                      ),
                      buildInventoryCard(
                        context,
                        title: 'STOCK PAKAN',
                        description: '9 APRIL 2025 : 200 BUAH',
                      ),
                      buildInventoryCard(
                        context,
                        title: 'STOCK ALAT',
                        description: '9 APRIL 2025 : 200 UNIT',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInventoryCard(BuildContext context, {
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          InventoryCard(
            title: title,
            description: description,
            imageUrl: 'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/c0f0d836a2bd2ef39df5c0bc24bfc50d4ce5f6f7?placeholderIfAbsent=true',
            
          ),
          
            Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // Aksi edit
            },
          ),
        ),

        ],
      ),
    );
  }
}
