import 'package:flutter/material.dart';
import 'package:eggxpress/widgets/profile_header.dart' as header;
import 'package:eggxpress/widgets/profile_action_button.dart' as action;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const header.ProfileHeader(),
              const SizedBox(height: 30),

              // Semua konten berada di tengah layar
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      action.ProfileActionButton(
                        text: 'Edit Profile Information',
                        onTap: () {
                          // Handle edit
                        },
                      ),
                      const SizedBox(height: 20),
                      action.ProfileActionButton(
                        text: 'Security',
                        onTap: () {
                          // Handle security
                        },
                      ),
                      const SizedBox(height: 35),

                      const Text(
                        'Ganti Akun',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                      ),

                      const SizedBox(height: 14),

                      ElevatedButton(
                        onPressed: () {
                          // Handle logout
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 60),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'LOGOUT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 46),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 4,
                      ),
                      width: 221,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/c8e668115457dd737479cad8dd10b9e2a578578f?placeholderIfAbsent=true',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                          Image.network(
                            'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/095b1c758230da75f4b5b00164300d10feb5886b?placeholderIfAbsent=true',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/0ee84e7fcd9794edb8ef050d2f1e66c3ee5794ff?placeholderIfAbsent=true',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 27),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
