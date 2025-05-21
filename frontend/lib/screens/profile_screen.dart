import 'package:flutter/material.dart';
import 'package:eggxpress/widgets/profile_header.dart' as header;
import 'package:eggxpress/widgets/profile_action_button.dart' as action;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const header.ProfileHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 45),
                    action.ProfileActionButton(
                      text: 'Edit profile information',
                      onTap: () {
                        // Handle edit profile
                      },
                    ),
                    const SizedBox(height: 30),
                    action.ProfileActionButton(
                      text: 'Security',
                      onTap: () {
                        // Handle security
                      },
                    ),
                    const SizedBox(height: 29),
                    const Text(
                      'Ganti akun',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 24.5 / 14,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 333),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle logout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9E4FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 70,
                          ),
                        ),
                        child: const Text(
                          'LOGOUT',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
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
