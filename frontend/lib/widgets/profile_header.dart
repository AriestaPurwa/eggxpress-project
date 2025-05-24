import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background dengan gelombang
        ClipPath(
          clipper: BottomWaveClipper(),
          child: Container(
            height: 260,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF005BEA), Color(0xFF00C6FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        // Konten profile (avatar, nama, email)
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(
                  'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/1db0a52187d2ccf61a87c3705481b0e9933652cf?placeholderIfAbsent=true',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'PEDAGANG',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'pedagang@gmail.com | 082234567890',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom ClipPath untuk gelombang bawah
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // mulai dari bawah kiri
    final firstControlPoint = Offset(size.width / 2, size.height);
    final firstEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.lineTo(size.width, 0); // kanan atas
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
