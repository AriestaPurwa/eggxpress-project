import 'package:flutter/material.dart';

class ProfileActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      constraints: const BoxConstraints(maxWidth: 338),
      child: Material(
        color: const Color(0xFFD9E4FF),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 66,
              vertical: 38,
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: 0.25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
