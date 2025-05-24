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

                      const SizedBox(height: 40),
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
}
