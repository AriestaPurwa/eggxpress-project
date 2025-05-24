import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 221,
      padding: const EdgeInsets.fromLTRB(12, 4, 26, 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/b07afdd0028d180f7762f7c7ea81d2ecbeca10b2?placeholderIfAbsent=true',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/095b1c758230da75f4b5b00164300d10feb5886b?placeholderIfAbsent=true',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/0098ec3a31a5408fa0df384f15fcd112/39b15e00c34209bb55a2e44a9570a3e1af039442?placeholderIfAbsent=true',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
