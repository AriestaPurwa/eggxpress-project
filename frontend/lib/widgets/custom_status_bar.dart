import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "9:41",
            style: AppTheme.statusBarTimeStyle,
          ),
          Row(
            children: [
              const SizedBox(width: 5),
              Icon(
                Icons.signal_cellular_4_bar,
                size: 17,
                color: Colors.black.withOpacity(0.9),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.wifi,
                size: 15,
                color: Colors.black.withOpacity(0.9),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.battery_full,
                size: 24,
                color: Colors.black.withOpacity(0.9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}