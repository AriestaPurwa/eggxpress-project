import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.202,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/6f64e87a6d190982db1bab33cfc79b9c85a5dde7?placeholderIfAbsent=true',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 62,
              vertical: 73,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/1db0a52187d2ccf61a87c3705481b0e9933652cf?placeholderIfAbsent=true',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 13),
                const Text(
                  'PEDAGANG',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'pedagang@gmail.com | 082234567890',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1,
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
